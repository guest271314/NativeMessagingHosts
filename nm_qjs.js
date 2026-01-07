#!/usr/bin/env -S /home/user/bin/qjs -m --std
// QuickJS Native Messaging host
// guest271314, 5-6-2022

function getMessage() {
  const header = new Uint32Array(1);
  std.in.read(header.buffer, 0, 4);
  const output = new Uint8Array(header[0]);
  const len = std.in.read(output.buffer, 0, output.length);
  return output;
}
// https://gist.github.com/guest271314/c88d281572aadb2cc6265e3e9eb09810
function sendMessage(message) {
  // Constants for readability
  const COMMA = 44;
  const OPEN_BRACKET = 91; // [
  const CLOSE_BRACKET = 93; // ]
  const CHUNK_SIZE = 1024 * 1024; // 1MB

  // If small enough, send directly (Native endianness handling recommended)
  if (message.length <= CHUNK_SIZE) {
    const header = new Uint8Array(4);
    header[0] = (message.length >> 0) & 0xff;
    header[1] = (message.length >> 8) & 0xff;
    header[2] = (message.length >> 16) & 0xff;
    header[3] = (message.length >> 24) & 0xff;

    // Two writes are often better than allocating a new joined buffer
    // if the engine supports it. If not, combine them.
    const output = new Uint8Array(4 + data.length);
    output.set(header, 0);
    output.set(data, 4);
    std.out.write(output.buffer, 0, output.length);
    std.out.flush();
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
    const dataLen = totalLength - 4;
    output[0] = (dataLen >> 0) & 0xff;
    output[1] = (dataLen >> 8) & 0xff;
    output[2] = (dataLen >> 16) & 0xff;
    output[3] = (dataLen >> 24) & 0xff;

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
    std.out.write(output.buffer, 0, output.length);
    std.out.flush();

    // Force GC only occasionally if needed (every chunk is often too frequent)
    std.gc();

    // Move index for next iteration
    index = splitIndex;
  }
}

function main() {
  while (true) {
    const message = getMessage();
    sendMessage(message);
  }
}

try {
  main();
} catch (e) {
  // std.writeFile("err.txt", e.message);
  std.exit(0);
}
