#!/usr/bin/env -S /home/user/bin/tjs run
// guest271314, 2-10-2023
//
// #!/usr/bin/env -S DENO_COMPAT=1 /home/user/bin/deno -A --v8-flags="--expose-gc"
// #!/usr/bin/env -S /home/user/bin/bun -b --expose-gc
// #!/usr/bin/env -S UV_THREADPOOL_SIZE=1 /home/user/bin/node --optimize-for-size --zero-unused-memory --memory-saver-mode --double-string-cache-size=1 --experimental-flush-embedded-blob-icache --jitless --expose-gc --v8-pool-size=1

if (!Object.hasOwn(globalThis, "process")) {
  if (navigator.userAgent.startsWith("txiki.js")) {
    Object.assign(globalThis, {
      process: {
        stdin: tjs.stdin,
        stdout: tjs.stdout.getWriter(),
        exit: tjs.exit,
      },
      gc: tjs.engine.gc.run,
    });
  }
}

process.stdout?._handle?.setBlocking(true);
process.stdin?._handle?.setBlocking(true);

const ab = new ArrayBuffer(0, { maxByteLength: 1024 ** 2 * 64 });
let totalMessageLength = 0;
let currentMessageLength = 0;

/**
 * Handles assembly of incoming stdin stream into messages.
 */
async function* getMessage() {
  let headerUint8 = new Uint8Array(0);

  const concatUint8 = (a, b) => {
    const res = new Uint8Array(a.length + b.length);
    res.set(a);
    res.set(b, a.length);
    return res;
  };

  for await (const data of process.stdin) {
    let chunk = new Uint8Array(data);

    while (chunk.length > 0) {
      // 1. Accumulate/Read the 4-byte length header
      if (totalMessageLength === 0) {
        if (headerUint8.length + chunk.length < 4) {
          headerUint8 = concatUint8(headerUint8, chunk);
          break;
        }

        const combinedHeader = concatUint8(
          headerUint8,
          chunk.subarray(0, 4 - headerUint8.length),
        );
        const view = new DataView(combinedHeader.buffer);
        totalMessageLength = view.getUint32(0, true);

        chunk = chunk.subarray(4 - headerUint8.length);
        headerUint8 = new Uint8Array(0);

        ab.resize(totalMessageLength);
        currentMessageLength = 0;
      }

      // 2. Fill the message buffer
      const remainingNeeded = totalMessageLength - currentMessageLength;
      const toCopy = chunk.subarray(0, remainingNeeded);

      new Uint8Array(ab).set(toCopy, currentMessageLength);
      currentMessageLength += toCopy.length;
      chunk = chunk.subarray(toCopy.length);

      // 3. Dispatch message when complete
      if (
        currentMessageLength === totalMessageLength && totalMessageLength > 0
      ) {
        yield new Uint8Array(ab);

        // Reset state for next message
        totalMessageLength = 0;
        currentMessageLength = 0;
        ab.resize(0);
        if (typeof gc === "function") gc();
      }
    }
  }
}

// https://gist.github.com/guest271314/c88d281572aadb2cc6265e3e9eb09810
/**
 * Sends messages to stdout with chunking for large payloads and backpressure handling.
 */
async function sendMessage(message) {
  const COMMA = 44;
  const OPEN_BRACKET = 91;
  const CLOSE_BRACKET = 93;
  const CHUNK_SIZE = 1024 * 1024; // 1MB

  // Internal helper to write and wait for drain if necessary
  const writeAndDrain = async (data) => {
    if (!process.stdout.write(data)) {
      await new Promise((resolve) =>
        process.stdout?.once ? process.stdout.once("drain", resolve) : resolve()
      );
    }
  };

  // Small message: Send directly
  if (message.length <= CHUNK_SIZE) {
    const header = new Uint8Array(4);
    new DataView(header.buffer).setUint32(0, message.length, true);
    await writeAndDrain(header);
    await writeAndDrain(message);
    return;
  }

  // Large message: Chunking logic to maintain JSON array validity
  let index = 0;
  while (index < message.length) {
    let splitIndex;
    let searchStart = index + CHUNK_SIZE - 8;

    if (searchStart >= message.length) {
      splitIndex = message.length;
    } else {
      splitIndex = message.indexOf(COMMA, searchStart);
      if (splitIndex === -1) splitIndex = message.length;
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
      if (endByte !== CLOSE_BRACKET) append = CLOSE_BRACKET;
    }

    let bodyLength = rawChunk.length;
    let sourceOffset = 0;
    if (startByte === COMMA) {
      sourceOffset = 1;
      bodyLength -= 1;
    }

    const hasPrepend = prepend !== null;
    const hasAppend = append !== null;
    const totalLength = 4 + (hasPrepend || startByte === COMMA ? 1 : 0) +
      bodyLength + (hasAppend ? 1 : 0);

    const output = new Uint8Array(totalLength);
    const dataLen = totalLength - 4;

    // Header
    const view = new DataView(output.buffer);
    view.setUint32(0, dataLen, true);

    let cursor = 4;
    if (hasPrepend || startByte === COMMA) {
      output[cursor] = OPEN_BRACKET;
      cursor++;
    }

    output.set(rawChunk.subarray(sourceOffset), cursor);
    cursor += bodyLength;

    if (hasAppend) {
      output[cursor] = append;
    }

    await writeAndDrain(output);
    index = splitIndex;
  }
}

/**
 * Main execution entry point
 */
async function main() {
  for await (const message of getMessage()) {
    await sendMessage(message);
  }
}

main().catch(() => process.exit(1));
