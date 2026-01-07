#!/usr/bin/env -S UV_THREADPOOL_SIZE=1 /home/user/bin/node --optimize-for-size --zero-unused-memory --memory-saver-mode --double-string-cache-size=1 --experimental-flush-embedded-blob-icache --jitless --expose-gc --v8-pool-size=1
// Node.js Native Messaging host
// guest271314, 10-9-2022

// /home/user/bin/deno -A --v8-flags="--expose-gc" --unstable-bare-node-builtins
// /home/user/bin/bun --expose-gc

// https://github.com/nodejs/node/issues/11568#issuecomment-282765300
process.stdout?._handle?.setBlocking(false);

const ab = new ArrayBuffer(0, { maxByteLength: 1024 ** 2 * 64 });
let totalMessageLength = 0;
let currentMessageLength = 0;

// https://gist.github.com/guest271314/c88d281572aadb2cc6265e3e9eb09810
function sendMessage(message) {
  // Constants for readability
  const COMMA = 44;
  const OPEN_BRACKET = 91; // [
  const CLOSE_BRACKET = 93; // ]
  const CHUNK_SIZE = 1024 * 1024; // 1MB

  // If small enough, send directly (Native endianness handling recommended)
  if (message.length <= CHUNK_SIZE) {
    process.stdout.write(new Uint32Array([message.length]));
    process.stdout.write(message);
    return;
  }

  let index = 0;

  // Iterate through the message until we reach the end
  while (index < message.length) {
    let splitIndex;

    // 1. Determine where to cut the chunk
    // Try to jump forward 1MB
    let searchStart = index + CHUNK_SIZE - 8;

    if (searchStart >= message.length) {
      // We are near the end, take everything remaining
      splitIndex = message.length;
    } else {
      // Find the next safe comma to split on
      splitIndex = message.indexOf(COMMA, searchStart);
      if (splitIndex === -1) {
        splitIndex = message.length; // No more commas, take the rest
      }
    }

    // 2. Extract the raw chunk (No copy yet, just a view)
    const rawChunk = message.subarray(index, splitIndex);

    // 3. Prepare the final payload buffer
    // We calculate size first to allocate exactly once per chunk
    const startByte = rawChunk[0];
    const endByte = rawChunk[rawChunk.length - 1];

    let prepend = null;
    let append = null;

    // Logic to ensure every chunk is a valid JSON array [...]
    // Case A: Starts with '[' (First chunk), needs ']' at end if not present
    if (startByte === OPEN_BRACKET && endByte !== CLOSE_BRACKET) {
      append = CLOSE_BRACKET;
    } // Case B: Starts with ',' (Middle chunks), needs '[' at start
    else if (startByte === COMMA) {
      prepend = OPEN_BRACKET;

      // If it doesn't end with ']', it needs one
      if (endByte !== CLOSE_BRACKET) {
        append = CLOSE_BRACKET;
      }
      // Note: We skip the leading comma in the raw copy later by offsetting
    }

    // 4. Construct the output buffer
    // Calculate final length: Header (4) + (Prepend?) + Body + (Append?)
    // Note: If startByte was COMMA, we usually want to overwrite it with '[',
    // but your original logic kept the comma data or shifted.
    // Standard approach:
    // If raw starts with comma, we replace comma with '[' or insert '['?
    // Your logic: Replaced [0] if it was comma.

    // Optimized construction based on your logic pattern:
    let bodyLength = rawChunk.length;
    let payloadOffset = 4; // Start after 4-byte header

    // Adjust sizes based on brackets
    const hasPrepend = prepend !== null;
    const hasAppend = append !== null;

    // Special handling for the "Comma Start" case to match your logic:
    // Your logic: x[0] = 91; x[i] = data[i]. Effectively replaces comma with '['
    let sourceOffset = 0;
    if (startByte === COMMA) {
      sourceOffset = 1; // Skip the comma from source
      bodyLength -= 1; // Reduce source len
      // We implicitly assume we prepend '[' in this slot
    }

    const totalLength = 4 + (hasPrepend ? 1 : 0) + bodyLength +
      (hasAppend ? 1 : 0);
    const output = new Uint8Array(totalLength);

    // Write Length Header (Little Endian example)
    const datacurrentMessageLength = totalLength - 4;
    output[0] = (datacurrentMessageLength >> 0) & 0xff;
    output[1] = (datacurrentMessageLength >> 8) & 0xff;
    output[2] = (datacurrentMessageLength >> 16) & 0xff;
    output[3] = (datacurrentMessageLength >> 24) & 0xff;

    // Write Prepend (e.g. '[')
    let cursor = 4;
    if (hasPrepend) {
      output[cursor] = prepend;
      cursor++;
    } else if (startByte === COMMA) {
      // If we didn't flag prepend but stripped comma, likely need bracket
      // Based on your specific logic "x[0] = 91", we treat that as a prepend
      output[cursor] = OPEN_BRACKET;
      cursor++;
    }

    // Write Body (Fast copy)
    // We use .set() which is much faster than a loop
    output.set(rawChunk.subarray(sourceOffset), cursor);
    cursor += bodyLength;

    // Write Append (e.g. ']')
    if (hasAppend) {
      output[cursor] = append;
    }

    // 5. Send immediately
    process.stdout.write(output);
    // Force GC only occasionally if needed (every chunk is often too frequent)

    // Move index for next iteration
    index = splitIndex;
  }
}

async function getMessage() {
  for await (const data of process.stdin) {
    if (
      ab.byteLength === 0 && totalMessageLength === 0 &&
      currentMessageLength === 0
    ) {
      const u8 = new Uint8Array(data);
      totalMessageLength = new DataView(u8.subarray(0, 4).buffer).getUint32(
        0,
        true,
      );
      ab.resize(totalMessageLength);
      const message = u8.subarray(4);
      new Uint8Array(ab).set(message, currentMessageLength);
      currentMessageLength += message.length;
    } else {
      if (currentMessageLength < totalMessageLength) {
        const u8 = new Uint8Array(ab);
        const message = new Uint8Array(data);
        u8.set(message, currentMessageLength);
        currentMessageLength += message.length;
      }
    }
    if (currentMessageLength === totalMessageLength) {
      sendMessage(new Uint8Array(ab));
      // await new Promise((resolve) => {
      //  process.stdout.once("drain", resolve);
      // });
      currentMessageLength = 0;
      totalMessageLength = 0;
      ab.resize(0);
      gc();
    }
  }
}

try {
  (async () => {
    await getMessage();
  })();
} catch (e) {
  process.exit(1);
}
