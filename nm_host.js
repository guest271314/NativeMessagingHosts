//! JavaScript runtime agnostic Native Messaging host
//! guest271314, 2-17-2024
//! Tested: Node.js, Deno, Bun, txiki.js
//!
//! #!/usr/bin/env -S /home/user/bin/bun -b --expose-gc
//! #!/usr/bin/env -S /home/user/bin/deno -A --v8-flags="--expose-gc"
//! #!/usr/bin/env -S /home/user/bin/node --expose-gc
//! #!/usr/bin/env -S /home/user/bin/tjs run

const runtime = navigator.userAgent;
const buffer = new ArrayBuffer(0, {
  maxByteLength: 1024 ** 2 * 64,
});
const encoder = new TextEncoder();
let totalMessageLength = 0;
let currentMessageLength = 0;
let readable, writable, writer, exit; // args

if (runtime.startsWith("Deno")) {
  ({ readable } = Deno.stdin);
  ({ writable } = Deno.stdout);
  ({ exit } = Deno);
  // ({ args } = Deno);
}

if (runtime.startsWith("Node")) {
  process.stdin._handle.setBlocking(!true);
  process.stdout._handle.setBlocking(!true);
  readable = process.stdin;
  writable = new WritableStream({
    write(value) {
      process.stdout.write(value);
    },
  });
  ({ exit } = process);
  //({ argv: args } = process);
}

if (runtime.startsWith("Bun")) {
  readable = Bun.stdin.stream();
  writable = new WritableStream({
    async write(value) {
      const fileSink = Bun.stdout.writer({ highWaterMark: Infinity });
      fileSink.start({ highWaterMark: Infinity });
      const n = fileSink.write(value);
      const nn = await Promise.all([fileSink.flush(), fileSink.end()]);
    },
  });
  ({ exit } = process);
  // ({ argv: args } = Bun);
}

if (runtime.startsWith("txiki.js")) {
  ({ stdin: readable } = tjs);
  ({ stdout: writable } = tjs);
  ({ exit } = tjs);
  globalThis.gc = tjs.engine.gc;
  //({ args } = tjs);
}

writer = writable.getWriter();

function encodeMessage(message) {
  return encoder.encode(JSON.stringify(message));
}

async function* getMessage() {
  for await (const data of readable) {
    const chunk = data;
    if (
      buffer.byteLength === 0 && totalMessageLength === 0 &&
      currentMessageLength === 0
    ) {
      totalMessageLength = chunk[3] << 24 | chunk[2] << 16 | chunk[1] << 8 |
        chunk[0];
      buffer.resize(totalMessageLength);
      const message = chunk.subarray(4);
      new Uint8Array(buffer).set(message, currentMessageLength);
      currentMessageLength += message.length;
    } else {
      if (currentMessageLength < totalMessageLength) {
        const u8 = new Uint8Array(buffer);
        u8.set(chunk, currentMessageLength);
        currentMessageLength += chunk.length;
      }
    }
    if (currentMessageLength === totalMessageLength) {
      yield new Uint8Array(buffer);
      currentMessageLength = 0;
      totalMessageLength = 0;
      buffer.resize(0);
      if (typeof gc === "function") {
        gc();
      }
    }
  }
}

async function sendMessage(message) {
  const COMMA = 44;
  const OPEN_BRACKET = 91;
  const CLOSE_BRACKET = 93;
  const CHUNK_SIZE = 1024 * 1024;
  const len = message.length;
  if (len <= CHUNK_SIZE) {
    const output = new Uint8Array(new ArrayBuffer(4 + len));
    output[0] = len >> 0 & 255;
    output[1] = len >> 8 & 255;
    output[2] = len >> 16 & 255;
    output[3] = len >> 24 & 255;
    output.set(message, 4);
    await writer.write(output);
    await writer.ready;
    return;
  }
  let index = 0;
  while (index < message.length) {
    let splitIndex;
    let searchStart = index + CHUNK_SIZE - 8;
    if (searchStart >= message.length) {
      splitIndex = message.length;
    } else {
      splitIndex = message.indexOf(COMMA, searchStart);
      if (splitIndex === -1) {
        splitIndex = message.length;
      }
    }
    const rawChunk = message.subarray(index, splitIndex);
    const startByte = rawChunk[0];
    const endByte = rawChunk[rawChunk.length - 1];
    let prepend = null;
    let append = null;
    if (startByte === OPEN_BRACKET && endByte !== CLOSE_BRACKET) {
      append = CLOSE_BRACKET;
    } else if (startByte === COMMA) {
      prepend = OPEN_BRACKET;
      if (endByte !== CLOSE_BRACKET) {
        append = CLOSE_BRACKET;
      }
    }
    let bodyLength = rawChunk.length;
    let sourceOffset = 0;
    if (startByte === COMMA) {
      sourceOffset = 1;
      bodyLength -= 1;
    }
    const totalLength = 4 + (prepend !== null ? 1 : 0) + bodyLength +
      (append !== null ? 1 : 0);
    const output = new Uint8Array(totalLength);
    const dataPayloadLen = totalLength - 4;
    output[0] = dataPayloadLen >> 0 & 255;
    output[1] = dataPayloadLen >> 8 & 255;
    output[2] = dataPayloadLen >> 16 & 255;
    output[3] = dataPayloadLen >> 24 & 255;
    let cursor = 4;
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
    await writer.write(output);
    await writer.ready;
    index = splitIndex;
  }
}

async function main() {
  for await (const message of getMessage()) {
    await sendMessage(message);
  }
}

main().catch((e) => {
  console.error(e.stack);
  sendMessage(encodeMessage({ error: e.message }));
  exit(1);
});

export { encodeMessage, exit, getMessage, readable, sendMessage, writable, writer };
