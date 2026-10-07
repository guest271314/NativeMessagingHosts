//! TypeScript Native Messaging host
//! guest271314, 7-28-2024, 10-6-2026
//!
//! scriptc targets ES2023 in tsconfig/base.json
//! #!/usr/bin/env -S /home/user/bin/bun x scriptc run
//! #!/usr/bin/env -S /home/user/bin/bun -b --expose-gc
//! #!/usr/bin/env -S /home/user/bin/deno -A --v8-flags="--expose-gc"
//! #!/usr/bin/env -S /home/user/bin/node --expose-gc

import * as process from "node:process";

// declare function gc(): void;

let buffer: Uint8Array = new Uint8Array(0);
const encoder: TextEncoder = new TextEncoder();
let totalMessageLength: number = 0;
let currentMessageLength: number = 0;

function encodeMessage(message: object): Uint8Array {
  return encoder.encode(JSON.stringify(message));
}

function findCommaIndex(
  array: Uint8Array,
  targetByte: number,
  startPosition: number,
): number {
  for (let i = startPosition; i < array.length; i++) {
    if (array[i] === targetByte) {
      return i;
    }
  }
  return -1;
}

async function* getMessage(): AsyncGenerator<Uint8Array> {
  for await (const data of process.stdin) {
    const chunk = data as Uint8Array;

    if (
      buffer.byteLength === 0 && totalMessageLength === 0 &&
      currentMessageLength === 0
    ) {
      totalMessageLength = (chunk[3] << 24) | (chunk[2] << 16) |
        (chunk[1] << 8) | chunk[0];
      buffer = new Uint8Array(totalMessageLength);

      const message = chunk.subarray(4);
      buffer.set(message, currentMessageLength);
      currentMessageLength += message.length;
    } else {
      if (currentMessageLength < totalMessageLength) {
        buffer.set(chunk, currentMessageLength);
        currentMessageLength += chunk.length;
      }
    }

    if (currentMessageLength === totalMessageLength) {
      yield buffer;

      currentMessageLength = 0;
      totalMessageLength = 0;
      buffer = new Uint8Array(0);
      //if (typeof gc === "function") gc();
    }
  }
}

function sendMessage(message: Uint8Array): void {
  const COMMA: number = 44;
  const OPEN_BRACKET: number = 91;
  const CLOSE_BRACKET: number = 93;
  const CHUNK_SIZE: number = 1024 * 1024;

  if (message.length <= CHUNK_SIZE) {
    const header = new Uint8Array(4);
    const len = message.length;
    header[0] = len & 0xff;
    header[1] = (len >> 8) & 0xff;
    header[2] = (len >> 16) & 0xff;
    header[3] = (len >> 24) & 0xff;

    process.stdout.write(header);
    process.stdout.write(message);
    return;
  }

  let index: number = 0;

  while (index < message.length) {
    let splitIndex: number;
    let searchStart: number = index + CHUNK_SIZE - 8;

    if (searchStart >= message.length) {
      splitIndex = message.length;
    } else {
      splitIndex = findCommaIndex(message, COMMA, searchStart);
      if (splitIndex === -1) {
        splitIndex = message.length;
      }
    }

    const rawChunk = message.subarray(index, splitIndex);
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

    const dataPayloadLen: number = totalLength - 4;
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

    process.stdout.write(output);
    index = splitIndex;
  }
}

async function main(): Promise<void> {
  for await (const message of getMessage()) {
    sendMessage(message);
  }
}

main().catch((e: unknown) => {
  if (e instanceof Error) {
    process.stderr.write(e.message);
    sendMessage(encodeMessage({ error: e.message }));
  } else {
    process.stderr.write("Unknown error occurred");
    sendMessage(encodeMessage({ error: "Unknown error occurred" }));
  }
  process.exit(1);
});
