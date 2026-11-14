//! Static Hermes Native Messaging host
//! guest271314, 10-2-2025

"use strict";

(function (exports) {
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

  // --- FFI Bindings ---
  const read_fd = $SHBuiltin.extern_c(
    { include: "nm_shermes.h" },
    function c_read_fd(
      fd: c_int,
      ptr: c_ptr,
      offset: c_size_t,
      len: c_size_t,
    ): c_int {
      throw 0;
    },
  );

  const write_fd = $SHBuiltin.extern_c(
    { include: "nm_shermes.h" },
    function c_write_fd(
      fd: c_int,
      ptr: c_ptr,
      offset: c_size_t,
      len: c_size_t,
    ): c_int {
      throw 0;
    },
  );

  const get_byte = $SHBuiltin.extern_c(
    { include: "nm_shermes.h" },
    function c_get_byte(ptr: c_ptr, offset: c_size_t): c_int {
      throw 0;
    },
  );

  const set_byte = $SHBuiltin.extern_c(
    { include: "nm_shermes.h" },
    function c_set_byte(ptr: c_ptr, offset: c_size_t, value: c_int): void {
      throw 0;
    },
  );

  const c_malloc = $SHBuiltin.extern_c(
    { include: "stdlib.h" },
    function malloc(size: c_size_t): c_ptr {
      throw 0;
    },
  );

  const c_exit = $SHBuiltin.extern_c(
    { include: "stdlib.h" },
    function exit(code: c_int): void {
      throw 0;
    },
  );
  // mem
  const copy_bytes = $SHBuiltin.extern_c(
    { include: "nm_shermes.h" },
    function c_copy(
      dst: c_ptr,
      dst_off: c_size_t,
      src: c_ptr,
      src_off: c_size_t,
      n: c_size_t,
    ): void {
      throw 0;
    },
  );

  const move_bytes = $SHBuiltin.extern_c(
    { include: "nm_shermes.h" },
    function c_move(
      dst: c_ptr,
      dst_off: c_size_t,
      src: c_ptr,
      src_off: c_size_t,
      n: c_size_t,
    ): void {
      throw 0;
    },
  );

  const index_of = $SHBuiltin.extern_c(
    { include: "nm_shermes.h" },
    function c_index_of(
      base: c_ptr,
      start: c_size_t,
      end: c_size_t,
      ch: c_int,
    ): c_int {
      throw 0;
    },
  );

  class SystemIO {
    read(
      fd: number,
      view: c_ptr,
      offset: number,
      len: number,
    ): number {
      const res: number = read_fd(fd, view, offset, len);
      return res;
    }

    write(
      fd: number,
      view: c_ptr,
      offset: number,
      len: number,
    ): number {
      const res: number = write_fd(fd, view, offset, len);
      return res;
    }
  }

  class NativeHostPipeline {
    io: SystemIO = new SystemIO();
    body: c_ptr = c_malloc(STREAM_BUFFER_SIZE);
    header: c_ptr = c_malloc(HEADER_SIZE);
    out: c_ptr = c_malloc(HEADER_SIZE + STREAM_BUFFER_SIZE + 2);
    util: c_ptr = c_malloc(UTILITY_BUFFER_SIZE);

    readLengthFromHeader(): number {
      const h: c_ptr = this.header;
      const s0: number = get_byte(h, 0);
      const s1: number = get_byte(h, 1);
      const s2: number = get_byte(h, 2);
      const s3: number = get_byte(h, 3);
      return ((s0 | (s1 << 8) | (s2 << 16) | (s3 << 24)) >>> 0);
    }

    writeBuffer(fd: number, u8: c_ptr, length: number): void {
      let offset: number = 0;
      while (offset < length) {
        const n: number = this.io.write(fd, u8, offset, length - offset);
        if (n <= 0) throw new Error("write returned 0");
        offset = offset + n;
      }
    }

    readExactBody(offset: number, length: number): void {
      let filled: number = 0;
      const view: c_ptr = this.body;
      while (filled < length) {
        const n: number = this.io.read(
          STDIN_FD,
          view,
          offset + filled,
          length - filled,
        );
        if (n <= 0) throw new Error("stdin closed prematurely");
        filled = filled + n;
      }
    }

    emit(from: number, to: number, prepend: number, append: number): void {
      const bodyLength: number = to - from;
      const payload: number = bodyLength + (prepend !== NO_BYTE ? 1 : 0) +
        (append !== NO_BYTE ? 1 : 0);
      const total: number = HEADER_SIZE + payload;
      const out: c_ptr = this.out;
      const body: c_ptr = this.body;

      set_byte(out, 0, payload & 255);
      set_byte(out, 1, (payload >> 8) & 255);
      set_byte(out, 2, (payload >> 16) & 255);
      set_byte(out, 3, (payload >> 24) & 255);

      let cursor: number = HEADER_SIZE;
      if (prepend !== NO_BYTE) {
        set_byte(out, cursor, prepend);
        cursor++;
      }
      /*
      let src: number = from;
      for (let i: number = 0; i < bodyLength; i++) {
        set_byte(out, cursor, get_byte(body, src));
        cursor++;
        src++;
      }
      */
      // mem
      copy_bytes(out, cursor, body, from, bodyLength);
      cursor = cursor + bodyLength;
      if (append !== NO_BYTE) {
        set_byte(out, cursor, append);
        cursor++;
      }

      this.writeBuffer(STDOUT_FD, out, total);
    }

    sendChunk(fromIndex: number, toIndex: number): void {
      const body: c_ptr = this.body;
      const startByte: number = get_byte(body, fromIndex);
      const endByte: number = get_byte(body, toIndex - 1);

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
      const body: c_ptr = this.body;

      while (remainingBytes > 0 || bufferPopulation > 0) {
        const spaceAvailable: number = STREAM_BUFFER_SIZE - bufferPopulation;
        const amountToRead: number = spaceAvailable < remainingBytes
          ? spaceAvailable
          : remainingBytes;

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
        const searchStart: number = chunkBacktrack < bufferPopulation
          ? chunkBacktrack
          : 0;
        const foundComma: number = index_of(
          body,
          searchStart,
          bufferPopulation,
          COMMA,
        );

        const splitIndex: number = foundComma !== -1 ? foundComma : CHUNK_SIZE;

        this.sendChunk(0, splitIndex);

        const remainingInWindow: number = bufferPopulation - splitIndex;
        move_bytes(body, 0, body, splitIndex, remainingInWindow);
        bufferPopulation = remainingInWindow;
      }
    }

    writeStringToUtilBuffer(str: string): number {
      const s: any = str;
      const len: number = s.length as number;
      const u: c_ptr = this.util;
      for (let i: number = 0; i < len; i++) {
        const cp: number = s.charCodeAt(i) as number;
        set_byte(u, i, cp);
      }
      return len;
    }

    writeManualErrorJson(msg: string): number {
      const u: c_ptr = this.util;
      let cursor: number = 0;
      set_byte(u, cursor++, 123); // {
      set_byte(u, cursor++, 34); // "
      set_byte(u, cursor++, 101); // e
      set_byte(u, cursor++, 114); // r
      set_byte(u, cursor++, 114); // r
      set_byte(u, cursor++, 111); // o
      set_byte(u, cursor++, 114); // r
      set_byte(u, cursor++, 34); // "
      set_byte(u, cursor++, 58); // :
      set_byte(u, cursor++, 34); // "

      const m: any = msg;
      const msgLen: number = m.length as number;
      for (let i: number = 0; i < msgLen; i++) {
        const cp: number = m.charCodeAt(i) as number;
        if (cp === 34 || cp === 92) {
          set_byte(u, cursor++, 92);
        }
        set_byte(u, cursor++, cp);
      }

      set_byte(u, cursor++, 34); // "
      set_byte(u, cursor++, 125); // }
      return cursor;
    }

    handleCrash(msg: string): void {
      const len: number = this.writeManualErrorJson(msg);
      this.writeBuffer(STDERR_FD, this.util, len);

      const body: c_ptr = this.body;
      const u: c_ptr = this.util;
      copy_bytes(body, 0, u, 0, len);
      this.sendChunk(0, len);

      c_exit(1);
    }

    mainProcessingLoop(): number {
      const header: c_ptr = this.header;
      let status: number = 0;
      while (true) {
        let bytesRead: number = 0;
        let filled: number = 0;
        while (filled < HEADER_SIZE) {
          const n: number = this.io.read(
            STDIN_FD,
            header,
            filled,
            HEADER_SIZE - filled,
          );
          if (n <= 0) {
            bytesRead = filled;
            break;
          }
          filled = filled + n;
          bytesRead = filled;
        }

        if (bytesRead === 0) {
          status = 0;
          break;
        }
        if (bytesRead < HEADER_SIZE) {
          status = 1;
          break;
        }

        const totalIncomingBytes: number = this.readLengthFromHeader();
        this.streamIncomingMessage(totalIncomingBytes);
      }
      return status;
    }
  }

  function run(): void {
    const pipeline: NativeHostPipeline = new NativeHostPipeline();
    const initMessage: string = '"Static Hermes Native Messaging streaming host"';

    const initLen: number = pipeline.writeStringToUtilBuffer(initMessage);
    pipeline.writeBuffer(STDERR_FD, pipeline.util, initLen);

    const statusCode: number = pipeline.mainProcessingLoop();
    if (statusCode === 1) {
      pipeline.handleCrash("stdin closed mid-header");
    }
  }

  run();
})({});

