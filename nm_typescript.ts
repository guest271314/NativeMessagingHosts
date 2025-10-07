/*
  #!/usr/bin/env -S /home/user/deno
  #!/usr/bin/env -S /home/user/bun
  #!/usr/bin/env -S /home/user/node

  TypeScript Native Messaging host
  guest271314, 7-28-2024
*/

// Source JavaScript: https://github.com/guest271314/NativeMessagingHosts/blob/main/nm_host.js
// https://github.com/microsoft/TypeScript/issues/62546#issuecomment-3374526284
import process from "node:process";
const runtime: string = navigator.userAgent;
const buffer: ArrayBuffer = new ArrayBuffer(0, { maxByteLength: 1024 ** 2 });
const view: DataView = new DataView(buffer);
const encoder: TextEncoder = new TextEncoder();

let readable: NodeJS.ReadStream & { fd: 0 } | ReadableStream<Uint8Array>,
  writable: WritableStream<Uint8Array>,
  exit: () => void = () => {};

if (runtime.startsWith("Deno")) {
  // @ts-ignore Deno
  ({ readable } = Deno.stdin);
  // @ts-ignore Deno
  ({ writable } = Deno.stdout);
  // @ts-ignore Deno
  ({ exit } = Deno);
}

if (runtime.startsWith("Node")) {
  readable = process.stdin;
  writable = new WritableStream({
    write(value) {
      process.stdout.write(value);
    },
  }, new CountQueuingStrategy({ highWaterMark: Infinity }));
  ({ exit } = process);
}

if (runtime.startsWith("Bun")) {
  // @ts-ignore Bun
  readable = Bun.file(0).stream();
  writable = new WritableStream<Uint8Array>({
    async write(value) {
      // @ts-ignore Bun
      Bun.file(1)
      .writer().write(value);
    },
  }, new CountQueuingStrategy({ highWaterMark: Infinity }));
  ({ exit } = process);
}

function encodeMessage(message: object): Uint8Array<ArrayBuffer> {
  return encoder.encode(JSON.stringify(message));
}

async function* getMessage(): AsyncGenerator<Uint8Array<ArrayBuffer>> {
  let messageLength: number = 0;
  let readOffset: number = 0;
  for await (let message of readable) {
    if (buffer.byteLength === 0 && messageLength === 0) {
      buffer.resize(4);
      for (let i = 0; i < 4; i++) {
        view.setUint8(i, message[i]);
      }
      messageLength = view.getUint32(0, true);
      message = message.subarray(4);
      buffer.resize(0);
    }
    buffer.resize(buffer.byteLength + message.length);
    for (let i = 0; i < message.length; i++, readOffset++) {
      view.setUint8(readOffset, message[i]);
    }
    if (buffer.byteLength === messageLength) {
      yield new Uint8Array(buffer);
      messageLength = 0;
      readOffset = 0;
      buffer.resize(0);
    }
  }
}

async function sendMessage(message: Uint8Array<ArrayBuffer>): Promise<void> {
  await new Blob([
    new Uint32Array([message.length]),
    message,
  ])
    .stream()
    .pipeTo(writable, { preventClose: true });
}

try {
  for await (const message of getMessage()) {
    await sendMessage(message);
  }
} catch (e: any) {
  sendMessage(encodeMessage(e.message));
  exit();
}

export { encodeMessage, exit, getMessage, readable, sendMessage, writable };
