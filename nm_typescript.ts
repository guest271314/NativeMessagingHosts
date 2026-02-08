// #!/usr/bin/env -S /home/user/bin/deno -A --v8-flags="--expose-gc"
// #!/usr/bin/env -S /home/user/bin/bun -b --expose-gc
// #!/usr/bin/env -S /home/user/bin/node --expose-gc
//
// TypeScript Native Messaging host
// guest271314, 7-28-2024

// Source JavaScript: https://github.com/guest271314/NativeMessagingHosts/blob/main/nm_host.js
// https://github.com/microsoft/TypeScript/issues/62546#issuecomment-3374526284
import * as process from "node:process";
// https://gemini.google.com/share/continue/4372b594e5a1
// 1. Extend the global scope for gc()
declare function gc(): void;

// 2. Define the types more strictly for Node.js usage
const stdin: NodeJS.ReadStream & { fd: 0 } = process.stdin;
const stdout: NodeJS.WriteStream & { fd: 1 } = process.stdout;
const exit: (n: number) => void = process.exit;

// 3. Cast stdout to 'any' briefly to access internal _handle, or use a type guard
(stdout as any)._handle?.setBlocking?.(false);

const buffer: ArrayBuffer = new ArrayBuffer(0, {
  maxByteLength: 1024 ** 2 * 64,
});

const encoder: TextEncoder = new TextEncoder();
let totalMessageLength: number = 0;
let currentMessageLength: number = 0;

function encodeMessage(message: object): Uint8Array {
  return encoder.encode(JSON.stringify(message));
}

async function* getMessage(): AsyncGenerator<Uint8Array<ArrayBuffer>> {
  for await (const data of stdin) {
    const chunk = data as Uint8Array; // Ensure data is treated as U8
    if (
      buffer.byteLength === 0 && totalMessageLength === 0 &&
      currentMessageLength === 0
    ) {
      totalMessageLength = new DataView(chunk.buffer, chunk.byteOffset, 4)
        .getUint32(
          0,
          true,
        );

      (buffer as any).resize(totalMessageLength);

      const message = chunk.subarray(4);
      new Uint8Array(buffer).set(message, currentMessageLength);
      currentMessageLength += message.length;
    } else {
      if (currentMessageLength < totalMessageLength) {
        const u8 = new Uint8Array(buffer);
        u8.set(chunk, currentMessageLength);
        currentMessageLength += chunk.length;
      }
    }      // Note: buffer.resize is a newer feature (ES2024).
      // Ensure your Node version supports it.

    if (currentMessageLength === totalMessageLength) {
      yield new Uint8Array(buffer);

      if (stdout.writableNeedDrain) {
        await new Promise((resolve) => {
          stdout.once("drain", resolve);
        });
      }

      currentMessageLength = 0;
      totalMessageLength = 0;
      (buffer as any).resize(0);
      if (typeof gc === "function") gc();
    }
  }
}

function sendMessage(message: Uint8Array): void {
  const COMMA: number = 44;
  const OPEN_BRACKET: number = 91;
  const CLOSE_BRACKET: number = 93;
  const CHUNK_SIZE: number = 1024 * 1024;

  if (message.length <= CHUNK_SIZE) {
    stdout.write(new Uint8Array(new Uint32Array([message.length]).buffer));
    stdout.write(message);
    return;
  }

  let index: number = 0;

  while (index < message.length) {
    let splitIndex: number;
    let searchStart = index + CHUNK_SIZE - 8;

    if (searchStart >= message.length) {
      splitIndex = message.length;
    } else {
      splitIndex = message.indexOf(COMMA, searchStart);
      if (splitIndex === -1) {
        splitIndex = message.length;
      }
    }

    const rawChunk: Uint8Array = message.subarray(index, splitIndex);
    const startByte: number = rawChunk[0];
    const endByte: number = rawChunk[rawChunk.length - 1];

    let prepend: number | null = null;
    let append: number | null = null;

    if (startByte === OPEN_BRACKET && endByte !== CLOSE_BRACKET) {
      append = CLOSE_BRACKET;
    } else if (startByte === COMMA) {
      prepend = OPEN_BRACKET;
      if (endByte !== CLOSE_BRACKET) {
        append = CLOSE_BRACKET;
      }
    }

    let bodyLength: number = rawChunk.length;
    let sourceOffset: number = 0;
    if (startByte === COMMA) {
      sourceOffset = 1;
      bodyLength -= 1;
    }

    const totalLength: number = 4 + (prepend !== null ? 1 : 0) + bodyLength +
      (append !== null ? 1 : 0);
    const output = new Uint8Array(totalLength);

    const dataPayloadLen = totalLength - 4;
    output[0] = (dataPayloadLen >> 0) & 0xff;
    output[1] = (dataPayloadLen >> 8) & 0xff;
    output[2] = (dataPayloadLen >> 16) & 0xff;
    output[3] = (dataPayloadLen >> 24) & 0xff;

    let cursor: number = 4;
    if (prepend !== null) {
      output[cursor] = prepend;
      cursor++;
    } else if (startByte === COMMA) {
      output[cursor] = OPEN_BRACKET;
      cursor++;
    }

    output.set(rawChunk.subarray(sourceOffset), cursor);
    cursor += bodyLength;

    if (append !== null) {
      output[cursor] = append;
    }

    stdout.write(output);
    index = splitIndex;
  }
}

async function main(): Promise<void> {
  for await (const message of getMessage()) {
    sendMessage(message);
  }
}

main().catch((e: Error) => {
  sendMessage(encodeMessage({ error: e.message }));
  exit(1);
});
