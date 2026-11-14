// JZ Native Messaging host
// guest271314 10-25-2026

import { readSync, writeSync } from "node:fs";
const STDIN_FD = 0;
const STDOUT_FD = 1;
const STDERR_FD = 2;
const HEADER_SIZE = 4;
const COMMA = 44;
const OPEN_BRACKET = 91;
const CLOSE_BRACKET = 93;
const NO_BYTE = -1;
const CHUNK_SIZE = 1024 * 1024;
const STREAM_BUFFER_SIZE = CHUNK_SIZE * 2;
const UTILITY_BUFFER_SIZE = 4096;

class SystemIO {
  static read(fd, view, offset, len) {
    const res = readSync(fd, view, offset, len, null);
    if (typeof res === "number")
      return res;
    return 0;
  }
  static write(fd, view, offset, len) {
    const res = writeSync(fd, view, offset, len);
    if (typeof res === "number")
      return res;
    return 0;
  }
}

class NativeHostPipeline {
  body = new Uint8Array(STREAM_BUFFER_SIZE);
  header = new Uint8Array(HEADER_SIZE);
  out = new Uint8Array(HEADER_SIZE + STREAM_BUFFER_SIZE + 2);
  util = new Uint8Array(UTILITY_BUFFER_SIZE);
  readLengthFromHeader() {
    const h = this.header;
    const s0 = h[0];
    const s1 = h[1];
    const s2 = h[2];
    const s3 = h[3];
    return (s0 | s1 << 8 | s2 << 16 | s3 << 24) >>> 0;
  }
  writeBuffer(fd, u8, length) {
    let offset = 0;
    while (offset < length) {
      const n = SystemIO.write(fd, u8, offset, length - offset);
      if (n === 0)
        throw new Error("write returned 0");
      if (typeof n === "number") {
        offset = offset + n;
      }
    }
  }
  readExactBody(offset, length) {
    let filled = 0;
    const view = this.body;
    while (filled < length) {
      const n = SystemIO.read(STDIN_FD, view, offset + filled, length - filled);
      if (n === 0)
        throw new Error("stdin closed prematurely");
      if (typeof n === "number") {
        filled = filled + n;
      }
    }
  }
  emit(from, to, prepend, append) {
    const bodyLength = to - from;
    const payload = bodyLength + (prepend !== NO_BYTE ? 1 : 0) + (append !== NO_BYTE ? 1 : 0);
    const total = HEADER_SIZE + payload;
    const out = this.out;
    const body = this.body;
    out[0] = payload & 255;
    out[1] = payload >> 8 & 255;
    out[2] = payload >> 16 & 255;
    out[3] = payload >> 24 & 255;
    let cursor = HEADER_SIZE;
    if (prepend !== NO_BYTE) {
      out[cursor] = prepend;
      cursor++;
    }
    let src = from;
    for (let i = 0;i < bodyLength; i++) {
      out[cursor] = body[src];
      cursor++;
      src++;
    }
    if (append !== NO_BYTE) {
      out[cursor] = append;
      cursor++;
    }
    this.writeBuffer(STDOUT_FD, out, total);
  }
  sendChunk(fromIndex, toIndex) {
    const body = this.body;
    const startByte = body[fromIndex];
    const endByte = body[toIndex - 1];
    let actualFrom = fromIndex;
    let prepend = NO_BYTE;
    let append = NO_BYTE;
    if (startByte === OPEN_BRACKET && endByte !== CLOSE_BRACKET) {
      append = CLOSE_BRACKET;
    } else if (startByte === COMMA) {
      actualFrom = fromIndex + 1;
      prepend = OPEN_BRACKET;
      if (endByte !== CLOSE_BRACKET) {
        append = CLOSE_BRACKET;
      }
    }
    this.emit(actualFrom, toIndex, prepend, append);
  }
  streamIncomingMessage(totalIncomingBytes) {
    let remainingBytes = totalIncomingBytes;
    let bufferPopulation = 0;
    const body = this.body;
    while (remainingBytes > 0 || bufferPopulation > 0) {
      const spaceAvailable = STREAM_BUFFER_SIZE - bufferPopulation;
      const amountToRead = spaceAvailable < remainingBytes ? spaceAvailable : remainingBytes;
      if (amountToRead > 0) {
        this.readExactBody(bufferPopulation, amountToRead);
        if (typeof amountToRead === "number") {
          bufferPopulation = bufferPopulation + amountToRead;
          remainingBytes = remainingBytes - amountToRead;
        }
      }
      if (bufferPopulation <= CHUNK_SIZE) {
        if (remainingBytes === 0) {
          if (bufferPopulation > 0) {
            this.sendChunk(0, bufferPopulation);
            bufferPopulation = 0;
          }
          break;
        }
        continue;
      }
      const chunkBacktrack = CHUNK_SIZE - 8;
      const searchStart = chunkBacktrack < bufferPopulation ? chunkBacktrack : 0;
      let foundComma = -1;
      for (let i = searchStart;i < bufferPopulation; i++) {
        if (body[i] === COMMA) {
          foundComma = i;
          break;
        }
      }
      const splitIndex = foundComma !== -1 ? foundComma : CHUNK_SIZE;
      this.sendChunk(0, splitIndex);
      const remainingInWindow = bufferPopulation - splitIndex;
      for (let i = 0;i < remainingInWindow; i++) {
        body[i] = body[splitIndex + i];
      }
      bufferPopulation = remainingInWindow;
    }
  }
  writeStringToUtilBuffer(str) {
    const len = str.length;
    const u = this.util;
    for (let i = 0;i < len; i++) {
      const cp = str.charCodeAt(i);
      u[i] = cp;
    }
    return len;
  }
  writeManualErrorJson(msg) {
    const u = this.util;
    let cursor = 0;
    u[cursor++] = 123;
    u[cursor++] = 34;
    u[cursor++] = 101;
    u[cursor++] = 114;
    u[cursor++] = 114;
    u[cursor++] = 111;
    u[cursor++] = 114;
    u[cursor++] = 34;
    u[cursor++] = 58;
    u[cursor++] = 34;
    const msgLen = msg.length;
    for (let i = 0;i < msgLen; i++) {
      const cp = msg.charCodeAt(i);
      if (cp === 34 || cp === 92) {
        u[cursor++] = 92;
      }
      u[cursor++] = cp;
    }
    u[cursor++] = 34;
    u[cursor++] = 125;
    return cursor;
  }
  handleCrash(msg) {
    const len = this.writeManualErrorJson(msg);
    this.writeBuffer(STDERR_FD, this.util, len);
    const body = this.body;
    const u = this.util;
    for (let i = 0;i < len; i++) {
      body[i] = u[i];
    }
    this.sendChunk(0, len);
    throw msg;
  }
  mainProcessingLoop() {
    const header = this.header;
    for (;; ) {
      let bytesRead = 0;
      let filled = 0;
      while (filled < HEADER_SIZE) {
        const n = SystemIO.read(STDIN_FD, header, filled, HEADER_SIZE - filled);
        if (n === 0) {
          bytesRead = filled;
          break;
        }
        if (typeof n === "number") {
          filled = filled + n;
        }
        bytesRead = filled;
      }
      if (bytesRead === 0)
        return 0;
      if (bytesRead < HEADER_SIZE)
        return 1;
      const totalIncomingBytes = this.readLengthFromHeader();
      this.streamIncomingMessage(totalIncomingBytes);
    }
  }
}
function run() {
  const pipeline = new NativeHostPipeline;
  const initMessage = '"TypeScript Native Messaging streaming host"';
  const initLen = pipeline.writeStringToUtilBuffer(initMessage);
  pipeline.writeBuffer(STDERR_FD, pipeline.util, initLen);
  const statusCode = pipeline.mainProcessingLoop();
  if (statusCode === 1) {
    pipeline.handleCrash("stdin closed mid-header");
  }
}
run();
