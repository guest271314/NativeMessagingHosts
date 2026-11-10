//! PerryTS/perry Native Messaging host
//! guest271314 11-9-2026

import { readSync, writeSync } from "node:fs";

const STDIN_FD: number = 0;
const STDOUT_FD: number = 1;
const STDERR_FD: number = 2;
const HEADER_SIZE: number = 4;
const COMMA: number = 44;
const OPEN_BRACKET: number = 91;
const CLOSE_BRACKET: number = 93;
const NO_BYTE: number = -1;

const CHUNK_SIZE: number = 1024 * 1024;
const STREAM_BUFFER_SIZE: number = CHUNK_SIZE * 2;
const UTILITY_BUFFER_SIZE: number = 4096;

class SystemIO {
  static read(fd: number, view: Uint8Array, offset: number, len: number): number {
    const res: number = readSync(fd, view, offset, len, null);
    if (typeof res === "number") return res;
    return 0;
  }
  static write(fd: number, view: Uint8Array, offset: number, len: number): number {
    const res: number = writeSync(fd, view, offset, len);
    if (typeof res === "number") return res;
    return 0;
  }
}

class NativeHostPipeline {
  body: Uint8Array = new Uint8Array(STREAM_BUFFER_SIZE);
  header: Uint8Array = new Uint8Array(HEADER_SIZE);
  out: Uint8Array = new Uint8Array(HEADER_SIZE + STREAM_BUFFER_SIZE + 2);
  util: Uint8Array = new Uint8Array(UTILITY_BUFFER_SIZE);

  readLengthFromHeader(): number {
    const h: Uint8Array = this.header;
    const s0: number = h[0];
    const s1: number = h[1];
    const s2: number = h[2];
    const s3: number = h[3];
    return ((s0 | (s1 << 8) | (s2 << 16) | (s3 << 24)) >>> 0);
  }

  writeBuffer(fd: number, u8: Uint8Array, length: number): void {
    let offset: number = 0;
    while (offset < length) {
      const n: number = SystemIO.write(fd, u8, offset, length - offset);
      if (n === 0) throw new Error("write returned 0");
      
      if (typeof n === "number") {
        offset = offset + n;
      }
    }
  }

  readExactBody(offset: number, length: number): void {
    let filled: number = 0;
    const view: Uint8Array = this.body;
    while (filled < length) {
      const n: number = SystemIO.read(STDIN_FD, view, offset + filled, length - filled);
      if (n === 0) throw new Error("stdin closed prematurely");
      
      if (typeof n === "number") {
        filled = filled + n;
      }
    }
  }

  emit(from: number, to: number, prepend: number, append: number): void {
    const bodyLength: number = to - from;
    const payload: number =
      bodyLength + (prepend !== NO_BYTE ? 1 : 0) + (append !== NO_BYTE ? 1 : 0);
    const total: number = HEADER_SIZE + payload;
    const out: Uint8Array = this.out;
    const body: Uint8Array = this.body;

    out[0] = payload & 255;
    out[1] = (payload >> 8) & 255;
    out[2] = (payload >> 16) & 255;
    out[3] = (payload >> 24) & 255;

    let cursor: number = HEADER_SIZE;
    if (prepend !== NO_BYTE) {
      out[cursor] = prepend;
      cursor++;
    }

    let src: number = from;
    for (let i: number = 0; i < bodyLength; i++) {
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

  sendChunk(fromIndex: number, toIndex: number): void {
    const body: Uint8Array = this.body;
    const startByte: number = body[fromIndex];
    const endByte: number = body[toIndex - 1];

    let actualFrom: number = fromIndex;
    let prepend: number = NO_BYTE;
    let append: number = NO_BYTE;

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

  streamIncomingMessage(totalIncomingBytes: number): void {
    let remainingBytes: number = totalIncomingBytes;
    let bufferPopulation: number = 0;
    const body: Uint8Array = this.body;

    while (remainingBytes > 0 || bufferPopulation > 0) {
      const spaceAvailable: number = STREAM_BUFFER_SIZE - bufferPopulation;
      const amountToRead: number =
        spaceAvailable < remainingBytes ? spaceAvailable : remainingBytes;

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

      const chunkBacktrack: number = CHUNK_SIZE - 8;
      const searchStart: number = chunkBacktrack < bufferPopulation ? chunkBacktrack : 0;
      
      let foundComma: number = -1;
      for (let i: number = searchStart; i < bufferPopulation; i++) {
        if (body[i] === COMMA) {
          foundComma = i;
          break;
        }
      }

      const splitIndex: number = foundComma !== -1 ? foundComma : CHUNK_SIZE;

      this.sendChunk(0, splitIndex);

      const remainingInWindow: number = bufferPopulation - splitIndex;
      for (let i: number = 0; i < remainingInWindow; i++) {
        body[i] = body[splitIndex + i];
      }
      bufferPopulation = remainingInWindow;
    }
  }

  writeStringToUtilBuffer(str: string): number {
    const len: number = str.length;
    const u: Uint8Array = this.util;
    for (let i: number = 0; i < len; i++) {
      const cp: number = str.charCodeAt(i);
      u[i] = cp;
    }
    return len;
  }

  writeManualErrorJson(msg: string): number {
    const u: Uint8Array = this.util;
    let cursor: number = 0;
    u[cursor++] = 123; // {
    u[cursor++] = 34;  // "
    u[cursor++] = 101; // e
    u[cursor++] = 114; // r
    u[cursor++] = 114; // r
    u[cursor++] = 111; // o
    u[cursor++] = 114; // r
    u[cursor++] = 34;  // "
    u[cursor++] = 58;  // :
    u[cursor++] = 34;  // "

    const msgLen: number = msg.length;
    for (let i: number = 0; i < msgLen; i++) {
      const cp: number = msg.charCodeAt(i);
      if (cp === 34 || cp === 92) {
        u[cursor++] = 92;
      }
      u[cursor++] = cp;
    }

    u[cursor++] = 34;  // "
    u[cursor++] = 125; // }
    return cursor;
  }

  handleCrash(msg: string): never {
    const len: number = this.writeManualErrorJson(msg);
    this.writeBuffer(STDERR_FD, this.util, len);

    const body: Uint8Array = this.body;
    const u: Uint8Array = this.util;
    for (let i: number = 0; i < len; i++) {
      body[i] = u[i];
    }
    this.sendChunk(0, len);
    
    // satisfies jz WASI runtime mapping
    process.exit(1);
    
    // Explicit scalar fallback guarantees a strict 'never' return type bounds context
    throw msg;
  }

  mainProcessingLoop(): number {
    const header: Uint8Array = this.header;
    for (;;) {
      let bytesRead: number = 0;
      let filled: number = 0;
      while (filled < HEADER_SIZE) {
        const n: number = SystemIO.read(STDIN_FD, header, filled, HEADER_SIZE - filled);
        if (n === 0) {
          bytesRead = filled;
          break;
        }
        
        if (typeof n === "number") {
          filled = filled + n;
        }
        bytesRead = filled;
      }

      if (bytesRead === 0) return 0;
      if (bytesRead < HEADER_SIZE) return 1;

      const totalIncomingBytes: number = this.readLengthFromHeader();
      this.streamIncomingMessage(totalIncomingBytes);
    }
  }
}

function run(): void {
  const pipeline: NativeHostPipeline = new NativeHostPipeline();
  const initMessage: string = '"TypeScript Native Messaging streaming host"';

  const initLen: number = pipeline.writeStringToUtilBuffer(initMessage);
  pipeline.writeBuffer(STDERR_FD, pipeline.util, initLen);

  const statusCode: number = pipeline.mainProcessingLoop();
  if (statusCode === 1) {
    pipeline.handleCrash("stdin closed mid-header");
  }
}

run();
