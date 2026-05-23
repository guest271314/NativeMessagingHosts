// JavaScript runtime agnostic Native Messaging host
// Tested: Node.js, Deno, Bun, txiki.js
// guest271314
/*
#!/usr/bin/env -S /home/user/bin/deno -A /home/user/bin/nm_host.js
#!/usr/bin/env -S /home/user/bin/node /home/user/bin/nm_host.js
#!/usr/bin/env -S /home/user/bin/bun -b --no-cache /home/user/bin/nm_host.js
#!/usr/bin/env -S /home/user/bin/tjs run
*/

const runtime = navigator.userAgent;
const buffer = new ArrayBuffer(0, { maxByteLength: 1024 ** 2 });
const view = new DataView(buffer);
const encoder = new TextEncoder();
const decoder = new TextDecoder();
const maxMessageLengthFromHost = 209715;
// const { dirname, filename, url } = import.meta;

let readable, writable, exit; //args

if (runtime.startsWith("Deno")) {
  ({ readable } = Deno.stdin);
  ({ writable } = Deno.stdout);
  ({ exit } = Deno);
  // ({ args } = Deno);
}

if (runtime.startsWith("Node")) {
  readable = process.stdin;
  writable = new WritableStream({
    write(value) {
      process.stdout.write(value);
    },
  });
  ({ exit } = process);
  // ({ argv: args } = process);
}

if (runtime.startsWith("Bun")) {
  readable = Bun.stdin.stream();
  writable = new WritableStream({
    async write(value) {
      const fileSink = Bun.stdout.writer({ highWaterMark: Infinity });
      fileSink.start({ highWaterMark: Infinity });
      const n0 = fileSink.write(value);
      const n1 = await fileSink.flush();
      const n2 = await fileSink.end();
    },
  });
  ({ exit } = process);
  // ({ argv: args } = Bun);
}

if (runtime.startsWith("txiki.js")) {
  ({ stdin: readable } = tjs);
  ({ stdout: writable } = tjs);
  ({ exit } = tjs);
  //({ args } = tjs);
}

const writer = writable.getWriter();

function encodeMessage(message) {
  return encoder.encode(JSON.stringify(message));
}

async function* getMessage() {
  let messageLength = 0;
  let readOffset = 0;
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

async function sendMessage(message) {
  const json = JSON.parse(decoder.decode(message));
  if (Array.isArray(json) && json.length > maxMessageLengthFromHost) {
    for (let i = 0; i < json.length; i += maxMessageLengthFromHost) {
      const messageChunk = encodeMessage(
        json.slice(i, i + maxMessageLengthFromHost),
      );
      const u8 = new Uint8Array(4 + messageChunk.length);
      u8.set(new Uint8Array(new Uint32Array([messageChunk.length]).buffer), 0);
      u8.set(messageChunk, 4);
      await writer.write(u8);
      await writer.ready;
    }
  } else {
    const encoded = encodeMessage(json);
    const u8 = new Uint8Array(4 + encoded.length);
    u8.set(new Uint8Array(new Uint32Array([encoded.length]).buffer), 0);
    u8.set(encoded, 4);
    return await writer.write(u8);
    await writer.ready;
  }
}

try {
  // await sendMessage(encodeMessage([{ dirname, filename, url }, ...args]));
  for await (const message of getMessage()) {
    await sendMessage(message);
  }
} catch (e) {
  sendMessage(encodeMessage(e.message));
  exit();
}

export { encodeMessage, exit, getMessage, readable, sendMessage, writable };
