// #!/usr/bin/env -S /home/user/bin/deno -A --v8-flags="--expose-gc"
// #!/usr/bin/env -S /home/user/bin/bun -b --expose-gc
// #!/usr/bin/env -S /home/user/bin/node --expose-gc
//
// TypeScript Native Messaging host
// guest271314, 7-28-2024

// Source JavaScript: https://github.com/guest271314/NativeMessagingHosts/blob/main/nm_host.js
// https://github.com/microsoft/TypeScript/issues/62546#issuecomment-3374526284
import process from "node:process";
process.stdout?._handle?.setBlocking(false);
const runtime: string = navigator.userAgent;
const buffer: ArrayBuffer = new ArrayBuffer(0, {
  maxByteLength: 1024 ** 2 * 64,
});
const view: DataView = new DataView(buffer);
const encoder: TextEncoder = new TextEncoder();
const decoder: TextDecoder = new TextDecoder();
const maxMessageLengthFromHost: number = 209715;
const readable: NodeJS.ReadStream & { fd: 0 } | ReadableStream<Uint8Array> =
    process.stdin,
  exit: () => void = process.exit;

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
  const json = await new Response(message).json();
  if (
    typeof json === "number" ||
    typeof json === "object" ||
    typeof json === "string" ||
    Array.isArray(json) &&
      json.length <= maxMessageLengthFromHost
  ) {
    process.stdout.write(new Uint32Array([message.length]));
    process.stdout.write(message);
    gc();
    return;
  }
  while (json.length) {
    const messageChunk = encoder.encode(
      JSON.stringify(json.splice(0, maxMessageLengthFromHost)),
    );
    process.stdout.write(new Uint32Array([messageChunk.length]));
    process.stdout.write(messageChunk);
    gc();
  }
}

try {
  for await (const message of getMessage()) {
    await sendMessage(message);
  }
} catch (e: any) {
  sendMessage(encodeMessage(e.message));
  exit();
}
