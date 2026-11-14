//! Native Messaging host, synchronous streaming stdio I/O - tslang version
//! tslang --emit=exe nm_tslang.ts
//! https://github.com/ASDAlexander77/TypeScriptCompiler/discussions/364
//! guest271314, ASDAlexander77 (https://github.com/ASDAlexander77) 11-9-2026
/*!
1. node:fs is not available, so SystemIO uses the default library's stdio functions, which take a position in the array:
  - stdio_read is fread on stdin. It waits until it has len bytes or stdin ends, so it suits this program, which always asks for an exact number of bytes.
  - stdio_write_bytes(fd, ...) takes 1 for stdout and 2 for stderr. Both put the stream in binary mode on Windows.
  - view.__elementRef(offset) gives the address of an element, so reads and writes can start at an offset (a Uint8Array here is not a view over an ArrayBuffer).
2. process.exit(1) becomes exit(1), with declare function exit(code: int): void; (the C library's exit).
3. The typeof n === "number" checks are not needed and are removed.

Everything else is unchanged.

Compile it into an executable, or run it with the JIT:

tslang --emit=exe nm_tslang.ts
tslang --emit=jit nm_tslang.ts
*/

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

declare function exit(code: int): void;

// node:fs readSync/writeSync with an offset, on top of the default library's stdio natives:
// stdio_read is fread on stdin (blocks until `len` bytes or the end of the input),
// stdio_write_bytes is fwrite on stdout (1) or stderr (2), both in binary mode.
class SystemIO {
  static read(fd: number, view: Uint8Array, offset: number, len: number): number {
    if (len <= 0) return 0;
    return stdio_read(<Opaque>view.__elementRef(offset), len);
  }
  static write(fd: number, view: Uint8Array, offset: number, len: number): number {
    if (len <= 0) return 0;
    return stdio_write_bytes(fd, <Opaque>view.__elementRef(offset), len);
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
      offset = offset + n;
    }
  }

  readExactBody(offset: number, length: number): void {
    let filled: number = 0;
    const view: Uint8Array = this.body;
    while (filled < length) {
      const n: number = SystemIO.read(STDIN_FD, view, offset + filled, length - filled);
      if (n === 0) throw new Error("stdin closed prematurely");
      filled = filled + n;
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
        bufferPopulation = bufferPopulation + amountToRead;
        remainingBytes = remainingBytes - amountToRead;
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

    exit(1);
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
        filled = filled + n;
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
  const initMessage: string = '"TypeScript Native Compiler Native Messaging streaming host"';

  const initLen: number = pipeline.writeStringToUtilBuffer(initMessage);
  pipeline.writeBuffer(STDERR_FD, pipeline.util, initLen);

  const statusCode: number = pipeline.mainProcessingLoop();
  if (statusCode === 1) {
    pipeline.handleCrash("stdin closed mid-header");
  }
}

run();
