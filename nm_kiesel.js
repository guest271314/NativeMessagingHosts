#!/usr/bin/env -S /home/user/bin/kiesel
// kiesel Native Messaging host
// guest271314, 10-07-2026
// https://codeberg.org/kiesel-js/kiesel/issues/239

const { Sysno, syscall, ptr } = Kiesel;

const STDIN = 0;
const STDOUT = 1;
const STDERR = 2;

function read(fd, buffer, length) {
  return syscall(Sysno.READ, fd, ptr(buffer), length);
}

function write(fd, buffer, length) {
  return syscall(Sysno.WRITE, fd, ptr(buffer), length);
}

function exit(statusCode = 0) {
  return syscall(Sysno.EXIT || 60, statusCode);
}

function encodeMessage(str) {
  const bytes = [];
  for (let i = 0; i < str.length; i++) {
    bytes.push(str.codePointAt(i));
  }
  return new Uint8Array(bytes);
}

function getMessage() {
  const header = new Uint32Array(1);
  let bytesRead = read(STDIN, header.buffer, 4);
  if (bytesRead <= 0) {
    return null;
  }
  const len = header[0];
  const output = new Uint8Array(len);
  let totalRead = 0;
  while (totalRead < len) {
    const chunk = new Uint8Array(65536);
    const n = read(STDIN, chunk.buffer, chunk.length);
    if (n <= 0) {
      break;
    }
    output.set(chunk.subarray(0, n), totalRead);
    totalRead += n;
  }
  return output;
}

function sendMessage(message) {
  const COMMA = 44;
  const OPEN_BRACKET = 91;
  const CLOSE_BRACKET = 93;
  const CHUNK_SIZE = 1024 * 1024;
  if (message.length <= CHUNK_SIZE) {
    const header = new Uint32Array([message.length]);
    write(STDOUT, header.buffer, header.buffer.byteLength);
    write(STDOUT, message.buffer, message.buffer.byteLength);
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
    let payloadOffset = 4;
    const hasPrepend = prepend !== null;
    const hasAppend = append !== null;
    let sourceOffset = 0;
    if (startByte === COMMA) {
      sourceOffset = 1;
      bodyLength -= 1;
    }
    const totalLength = 4 + (hasPrepend ? 1 : 0) + bodyLength +
      (hasAppend ? 1 : 0);
    const output = new Uint8Array(totalLength);
    const dataLen = totalLength - 4;
    output[0] = dataLen >> 0 & 255;
    output[1] = dataLen >> 8 & 255;
    output[2] = dataLen >> 16 & 255;
    output[3] = dataLen >> 24 & 255;
    let cursor = 4;
    if (hasPrepend) {
      output[cursor] = prepend;
      cursor++;
    } else if (startByte === COMMA) {
      output[cursor] = OPEN_BRACKET;
      cursor++;
    }
    output.set(rawChunk.subarray(sourceOffset), cursor);
    cursor += bodyLength;
    if (hasAppend) {
      output[cursor] = append;
    }
    write(STDOUT, output.buffer, output.length);
    index = splitIndex;
  }
}

function main() {
  while (true) {
    const message = getMessage();
    if (message) {
      sendMessage(message);
    }
  }
}

try {
  main();
} catch (e) {
  const errMessage = encodeMessage(`${e?.message}`);
  write(STDERR, errMessage.buffer, errMessage.buffer.byteLength);
  exit(1);
} finally {
  exit();
}
