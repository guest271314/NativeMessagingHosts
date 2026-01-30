// Javy Native Messaging host
// guest271314, August 2024
const stdin = 0;
const stdout = 1;
const encoder = new TextEncoder();

function getMessage() {
  const header = new Uint8Array(4);
  const bytesRead = Javy.IO.readSync(stdin, header);

  // If we can't read 4 bytes, the pipe is closed.
  if (bytesRead < 4) {
    return null;
  }

  const length = new Uint32Array(header.buffer)[0];
  const message = new Uint8Array(length);
  let offset = 0;

  while (offset < length) {
    // Read remaining bytes directly into the target buffer offset
    const bytesRead = Javy.IO.readSync(stdin, message.subarray(offset));
    if (bytesRead === 0) break; // Unexpected EOF
    offset += bytesRead;
  }
  return message;
}

function sendMessage(message) {
  const COMMA = 44;
  const OPEN_BRACKET = 91;
  const CLOSE_BRACKET = 93;
  const CHUNK_SIZE = 1024 * 1024;

  // Helper for direct output
  const writeFinal = (data) => {
    const header = new Uint8Array(4);
    const len = data.length;
    header[0] = len & 0xff;
    header[1] = (len >> 8) & 0xff;
    header[2] = (len >> 16) & 0xff;
    header[3] = (len >> 24) & 0xff;

    const output = new Uint8Array(4 + len);
    output.set(header, 0);
    output.set(data, 4);
    Javy.IO.writeSync(stdout, output);
  };

  if (message.length <= CHUNK_SIZE) {
    writeFinal(message);
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
      if (splitIndex === -1) splitIndex = message.length;
    }

    const rawChunk = message.subarray(index, splitIndex);
    const startByte = rawChunk[0];
    const endByte = rawChunk[rawChunk.length - 1];

    let hasPrepend = false;
    let hasAppend = false;
    let sourceOffset = 0;

    if (startByte === OPEN_BRACKET && endByte !== CLOSE_BRACKET) {
      hasAppend = true;
    } else if (startByte === COMMA) {
      hasPrepend = true;
      sourceOffset = 1;
      if (endByte !== CLOSE_BRACKET) hasAppend = true;
    }

    const bodyLength = rawChunk.length - sourceOffset;
    const totalLength = 4 + (hasPrepend ? 1 : 0) + bodyLength +
      (hasAppend ? 1 : 0);
    const output = new Uint8Array(totalLength);

    // Header
    const dataLen = totalLength - 4;
    output[0] = dataLen & 0xff;
    output[1] = (dataLen >> 8) & 0xff;
    output[2] = (dataLen >> 16) & 0xff;
    output[3] = (dataLen >> 24) & 0xff;

    let cursor = 4;
    if (hasPrepend) output[cursor++] = OPEN_BRACKET;
    output.set(rawChunk.subarray(sourceOffset), cursor);
    cursor += bodyLength;
    if (hasAppend) output[cursor] = CLOSE_BRACKET;

    Javy.IO.writeSync(stdout, output);
    index = splitIndex;
  }
}

function main() {
  while (true) {
    try {
      const message = getMessage();
      // If getMessage returns null, the browser closed the connection
      if (message === null) {
        break;
      }
      sendMessage(message);
    } catch (e) {
      // Log or handle error - but don't try to send to stdout
      // if stdout is the thing that crashed.
      break;
    }
  }
}

main();
