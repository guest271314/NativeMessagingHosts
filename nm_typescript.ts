// TypeScript Native Messaging host
// guest271314, 7-28-2024
/*
#!/usr/bin/env -S /home/user/bin/deno -A
#!/usr/bin/env -S /home/user/bin/bun run 
#!/usr/bin/env -S /home/user/bin/node --experimental-default-type=module --experimental-transform-types
*/
/*.
declare let readable: NodeJS.ReadStream & {
    fd: 0;
} | ReadableStream<Uint8Array>, writable: WritableStream<Uint8Array>, exit: () => void;
declare function encodeMessage(message: any): Uint8Array;
declare function getMessage(): AsyncGenerator<Uint8Array>;
declare function sendMessage(message: Uint8Array): Promise<void>;
export { encodeMessage, exit, getMessage, readable, sendMessage, writable, };
*/
// Source JavaScript: https://github.com/guest271314/NativeMessagingHosts/blob/main/nm_host.js
// Convert JavaScript to TypeScript, no obvious equivalent with tsc
// https://www.codeconvert.ai/javascript-to-typescript-converter
const runtime: string = navigator.userAgent;
// Resizable ArrayBuffer supported by tsc Version 5.7.0-dev.20241019
/**
* /// <reference types="https://raw.githubusercontent.com/microsoft/TypeScript/eeffd209154b122d4b9d0eaca44526a2784073ae/src/lib/es2024.arraybuffer.d.ts" />
*/
const buffer: ArrayBuffer = new ArrayBuffer(0, { maxByteLength: 1024 ** 2 });
const view: DataView = new DataView(buffer);
const encoder: TextEncoder = new TextEncoder();

let readable: NodeJS.ReadStream & { fd: 0; } | ReadableStream<Uint8Array>,
  writable: WritableStream<Uint8Array>,
  exit: () => void;

if (runtime.startsWith("Deno")) {
  ({ readable } = Deno.stdin);
  ({ writable } = Deno.stdout);
  ({ exit } = Deno);
}

if (runtime.startsWith("Node")) {
  readable = (await import("node:process")).stdin;
  writable = new WritableStream({
    write(value) {
      process.stdout.write(value);
    },
  }, new CountQueuingStrategy({ highWaterMark: Infinity }));
  ({ exit } = process);
}

if (runtime.startsWith("Bun")) {
  readable = Bun.file("/dev/stdin").stream();
  writable = new WritableStream<Uint8Array>({
    async write(value) {
      await Bun.write(Bun.stdout, value);
    },
  }, new CountQueuingStrategy({ highWaterMark: Infinity }));
  ({ exit } = process);
}

function encodeMessage(message: any): Uint8Array {
  return encoder.encode(JSON.stringify(message));
}

async function* getMessage(): AsyncGenerator<Uint8Array> {
  let messageLength: number = 0;
  let readOffset: number = 0;
  for await (let message of readable) {
    if (buffer.byteLength === 0) {
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

async function sendMessage(message: Uint8Array): Promise<void> {
  await new Blob([
    new Uint8Array(new Uint32Array([message.length]).buffer),
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

export {
  encodeMessage,
  exit,
  getMessage,
  readable,
  sendMessage,
  writable,
};
