// TypeScript Native Messaging host
// guest271314, 7-28-2024
/*
#!/usr/bin/env -S /home/user/bin/deno run
#!/usr/bin/env -S /home/user/bin/bun run 
#!/usr/bin/env -S /home/user/bin/node --experimental-default-type=module --experimental-strip-types
*/
  /**
  * /// <reference types="https://raw.githubusercontent.com/microsoft/TypeScript/eeffd209154b122d4b9d0eaca44526a2784073ae/src/lib/es2024.arraybuffer.d.ts" />
  */
interface ArrayBuffer {
  /**
   * If this ArrayBuffer is resizable, returns the maximum byte length given during construction; returns the byte length if not.
   *
   * [MDN](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer/maxByteLength)
   */
  get maxByteLength(): number;

  /**
   * Returns true if this ArrayBuffer can be resized.
   *
   * [MDN](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer/resizable)
   */
  get resizable(): boolean;

  /**
   * Resizes the ArrayBuffer to the specified size (in bytes).
   *
   * [MDN](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer/resize)
   */
  resize(newByteLength?: number): void;

  /**
   * Returns a boolean indicating whether or not this buffer has been detached (transferred).
   *
   * [MDN](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer/detached)
   */
  get detached(): boolean;

  /**
   * Creates a new ArrayBuffer with the same byte content as this buffer, then detaches this buffer.
   *
   * [MDN](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer/transfer)
   */
  transfer(newByteLength?: number): ArrayBuffer;

  /**
   * Creates a new non-resizable ArrayBuffer with the same byte content as this buffer, then detaches this buffer.
   *
   * [MDN](https://developer.mozilla.org/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer/transferToFixedLength)
   */
  transferToFixedLength(newByteLength?: number): ArrayBuffer;
}

interface ArrayBufferConstructor {
  new (byteLength: number, options?: { maxByteLength?: number }): ArrayBuffer;
}

// Convert JavaScript to TypeScript, no obvious equivalent with tsc
// https://www.codeconvert.ai/javascript-to-typescript-converter
// But wait, there's https://www.typescriptlang.org/docs/handbook/declaration-files/dts-from-js.html

const runtime: string = navigator.userAgent;
const buffer: ArrayBuffer = new ArrayBuffer(0, { maxByteLength: 1024 ** 2 });
const view: DataView = new DataView(buffer);
const encoder: TextEncoder = new TextEncoder();
const { dirname, filename, url } = import.meta;

let readable: ReadableStream<Uint8Array>,
  writable: WritableStream<Uint8Array>,
  exit: () => void,
  args: string[];

if (runtime.startsWith("Deno")) {
  ({ readable } = Deno.stdin);
  ({ writable } = Deno.stdout);
  ({ exit } = Deno);
  ({ args } = Deno);
}

if (runtime.startsWith("Node")) {
  readable = process.stdin;
  writable = new WritableStream({
    write(value) {
      process.stdout.write(value);
    },
  }, new CountQueuingStrategy<Uint8Array>({ highWaterMark: Infinity }));
  ({ exit } = process);
  ({ argv: args } = process);
}

if (runtime.startsWith("Bun")) {
  readable = Bun.file("/dev/stdin").stream();
  writable = new WritableStream<Uint8Array>({
    async write(value) {
      await Bun.write(Bun.stdout, value);
    },
  }, new CountQueuingStrategy<Uint8Array>({ highWaterMark: Infinity }));
  ({ exit } = process);
  ({ argv: args } = Bun);
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
  await sendMessage(encodeMessage([{ dirname, filename, url }, ...args]));
  for await (const message of getMessage()) {
    await sendMessage(message);
  }
} catch (e) {
  sendMessage(encodeMessage(e.message));
  exit();
}

/*
export {
  args,
  encodeMessage,
  exit,
  getMessage,
  readable,
  sendMessage,
  writable,
};
*/
