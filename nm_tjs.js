#!/usr/bin/env -S /home/user/bin/tjs run
// txiki.js Native Messaging host
// guest271314, 2-10-2023
// 
// https://github.com/denoland/deno/discussions/17236#discussioncomment-4566134
// https://github.com/saghul/txiki.js/blob/master/src/js/core/tjs/eval-stdin.js
// https://gemini.google.com/share/continue/4372b594e5a1
/**
 * READS a message from stdin
 * Handled asynchronously for txiki.js
 */
async function getMessage() {
  const header = new Uint8Array(4);
  let readHeader = 0;

  // 1. Read the 4-byte length header
  while (readHeader < 4) {
    const n = await tjs.stdin.read(header.subarray(readHeader));
    if (n === null || n === 0) return null; // Pipe closed
    readHeader += n;
  }

  const length = (header[0]) | (header[1] << 8) | (header[2] << 16) |
    (header[3] << 24);
  const output = new Uint8Array(length);
  let readBody = 0;

  // 2. Read the body based on the header length
  while (readBody < length) {
    const n = await tjs.stdin.read(output.subarray(readBody));
    if (n === null || n === 0) break;
    readBody += n;
  }

  return output;
}

/**
 * SENDS a message to stdout
 * Chunked logic adapted for txiki.js asynchronous output
 */
async function sendMessage(message) {
  const COMMA = 44;
  const OPEN_BRACKET = 91;
  const CLOSE_BRACKET = 93;
  const CHUNK_SIZE = 1024 * 1024; // 1MB

  // Case 1: Small message
  if (message.length <= CHUNK_SIZE) {
    const output = new Uint8Array(4 + message.length);
    output[0] = (message.length >> 0) & 0xff;
    output[1] = (message.length >> 8) & 0xff;
    output[2] = (message.length >> 16) & 0xff;
    output[3] = (message.length >> 24) & 0xff;
    output.set(message, 4);

    await tjs.stdout.write(output);
    return;
  }

  // Case 2: Large message (Chunking logic)
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

    let hasPrepend = startByte === COMMA;
    let hasAppend = endByte !== CLOSE_BRACKET;

    // Match original logic: if start is '[', ensure it has ']'
    if (startByte === OPEN_BRACKET && endByte !== CLOSE_BRACKET) {
      hasAppend = true;
    }

    let sourceOffset = (startByte === COMMA) ? 1 : 0;
    let bodyLength = rawChunk.length - sourceOffset;

    // Total = Header(4) + Prepend(1 if comma/needed) + Body + Append(1 if needed)
    const totalLength = 4 + (hasPrepend ? 1 : 0) + bodyLength +
      (hasAppend ? 1 : 0);
    const output = new Uint8Array(totalLength);

    // Write Header
    const payloadLen = totalLength - 4;
    output[0] = (payloadLen >> 0) & 0xff;
    output[1] = (payloadLen >> 8) & 0xff;
    output[2] = (payloadLen >> 16) & 0xff;
    output[3] = (payloadLen >> 24) & 0xff;

    let cursor = 4;
    if (hasPrepend) {
      output[cursor++] = OPEN_BRACKET;
    }

    output.set(rawChunk.subarray(sourceOffset), cursor);
    cursor += bodyLength;

    if (hasAppend) {
      output[cursor] = CLOSE_BRACKET;
    }

    await tjs.stdout.write(output);

    // Increment and GC
    index = splitIndex;
    if (index % (CHUNK_SIZE * 5) === 0) {
      tjs.engine.gc.run();
    }
  }
}

/**
 * MAIN LOOP
 */
async function main() {
  try {
    while (true) {
      const message = await getMessage();
      await sendMessage(message);
      tjs.engine.gc.run();
    }
  } catch (e) {
    // Log error and exit gracefully
    const err = tjs.open("err.txt", "w", 0o755);
    err.then(() => err.write(new TextEncoder().encode(e.message)))
      .then(() => err.close())
      .then(() => tjs.exit(1));
  }
}

main();
