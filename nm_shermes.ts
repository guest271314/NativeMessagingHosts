// Static Hermes Native Messaging host
// guest271314, 10-2-2035
"use strict";

(function (exports) {
  const CHUNK_SIZE = 1024 * 1024;
  const SEARCH_WINDOW = 8;

  // --- FFI Bindings ---
  const get_stdin = $SHBuiltin.extern_c(
    { include: "nm_shermes.h" },
    function get_c_stdin(): c_ptr {
      throw 0;
    },
  );

  const get_stdout = $SHBuiltin.extern_c(
    { include: "nm_shermes.h" },
    function get_c_stdout(): c_ptr {
      throw 0;
    },
  );

  const read_uint32_le = $SHBuiltin.extern_c(
    { include: "nm_shermes.h" },
    function c_read_uint32_le(ptr: c_ptr): c_int {
      throw 0;
    },
  );

  const write_uint32_le = $SHBuiltin.extern_c(
    { include: "nm_shermes.h" },
    function c_write_uint32_le(ptr: c_ptr, val: c_int): void {
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

  const find_mem_char = $SHBuiltin.extern_c(
    { include: "nm_shermes.h" },
    function c_memchr(ptr: c_ptr, ch: c_int, out_len: c_size_t): c_ptr {
      throw 0;
    },
  );

  const ptr_add = $SHBuiltin.extern_c(
    { include: "nm_shermes.h" },
    function c_ptr_add(ptr: c_ptr, offset: c_size_t): c_ptr {
      throw 0;
    },
  );

  const ptr_diff = $SHBuiltin.extern_c(
    { include: "nm_shermes.h" },
    function c_ptr_diff(ptr1: c_ptr, ptr2: c_ptr): c_size_t {
      throw 0;
    },
  );

  const get_null_ptr = $SHBuiltin.extern_c(
    { include: "nm_shermes.h" },
    function c_null_ptr(): c_ptr {
      throw 0;
    },
  );

  const is_ptr_null = $SHBuiltin.extern_c(
    { include: "nm_shermes.h" },
    function c_is_null(ptr: c_ptr): c_int {
      throw 0;
    },
  );

  const c_fread = $SHBuiltin.extern_c(
    { include: "stdio.h" },
    function fread(
      ptr: c_ptr,
      size: c_size_t,
      count: c_size_t,
      stream: c_ptr,
    ): c_size_t {
      throw 0;
    },
  );

  const c_fwrite = $SHBuiltin.extern_c(
    { include: "stdio.h" },
    function fwrite(
      ptr: c_ptr,
      size: c_size_t,
      count: c_size_t,
      stream: c_ptr,
    ): c_size_t {
      throw 0;
    },
  );

  const c_fputc = $SHBuiltin.extern_c(
    { include: "stdio.h" },
    function fputc(ch: c_int, stream: c_ptr): c_int {
      throw 0;
    },
  );

  const c_fflush = $SHBuiltin.extern_c(
    { include: "stdio.h" },
    function fflush(stream: c_ptr): c_int {
      throw 0;
    },
  );

  const c_malloc = $SHBuiltin.extern_c(
    { include: "stdlib.h" },
    function malloc(size: c_size_t): c_ptr {
      throw 0;
    },
  );

  const c_free = $SHBuiltin.extern_c(
    { include: "stdlib.h" },
    function free(ptr: c_ptr): void {
      throw 0;
    },
  );

  // --- High-Performance Ingestion Engine ---
  function getMessage(
    stdinStream: c_ptr,
    headerBuf: c_ptr,
    outLengthBuf: c_ptr,
  ): c_ptr {
    let bytesReadHeader = c_fread(headerBuf, 1, 4, stdinStream);
    if (bytesReadHeader !== 4) {
      write_uint32_le(outLengthBuf, 0);
      return get_null_ptr();
    }

    let messageLength = read_uint32_le(headerBuf);
    if (messageLength === 0 || messageLength > (64 << 20)) {
      write_uint32_le(outLengthBuf, 0);
      return get_null_ptr();
    }

    let messageBuffer = c_malloc(messageLength + 1);
    if (is_ptr_null(messageBuffer) === 1) {
      write_uint32_le(outLengthBuf, 0);
      return get_null_ptr();
    }

    let bytesReadPayload = c_fread(
      messageBuffer,
      1,
      messageLength,
      stdinStream,
    );
    if (bytesReadPayload !== messageLength) {
      c_free(messageBuffer);
      write_uint32_le(outLengthBuf, 0);
      return get_null_ptr();
    }

    set_byte(messageBuffer, messageLength, 0);
    write_uint32_le(outLengthBuf, messageLength);
    return messageBuffer;
  }

  // --- High-Performance Zero-Allocation Chunked Stream Transmitter ---
  function sendMessage(
    messagePtr: c_ptr,
    length: number,
    stdoutStream: c_ptr,
    headerBuf: c_ptr,
  ): void {
    if (is_ptr_null(messagePtr) === 1 || length === 0) return;

    if (length <= CHUNK_SIZE) {
      write_uint32_le(headerBuf, length);
      c_fwrite(headerBuf, 1, 4, stdoutStream);
      c_fwrite(messagePtr, 1, length, stdoutStream);
      c_fflush(stdoutStream);
      return;
    }

    let index = 0;
    while (index < length) {
      let remaining = length - index;
      let splitIndex = length;

      if (remaining > CHUNK_SIZE) {
        let searchStartOffset = index + CHUNK_SIZE - SEARCH_WINDOW;
        let searchPtr = ptr_add(messagePtr, searchStartOffset);
        let searchLen = length - searchStartOffset;

        let commaPtr = find_mem_char(searchPtr, 44, searchLen);
        if (is_ptr_null(commaPtr) === 0) {
          splitIndex = ptr_diff(commaPtr, messagePtr);
        }
      }

      let chunkStartPtr = ptr_add(messagePtr, index);
      let chunkLen = splitIndex - index;

      let firstChar = get_byte(chunkStartPtr, 0);
      let lastChar = get_byte(chunkStartPtr, chunkLen - 1);

      let bodyPtr = chunkStartPtr;
      let bodyLen = chunkLen;
      let prependChar = 0;
      let appendChar = 0;

      if (firstChar === 91) {
        if (lastChar !== 93) appendChar = 93;
      } else if (firstChar === 44) {
        prependChar = 91;
        bodyPtr = ptr_add(bodyPtr, 1);
        bodyLen--;
        if (lastChar !== 93) appendChar = 93;
      }

      let totalChunkLen = bodyLen + (prependChar ? 1 : 0) +
        (appendChar ? 1 : 0);
      write_uint32_le(headerBuf, totalChunkLen);

      c_fwrite(headerBuf, 1, 4, stdoutStream);
      if (prependChar) c_fputc(prependChar, stdoutStream);
      c_fwrite(bodyPtr, 1, bodyLen, stdoutStream);
      if (appendChar) c_fputc(appendChar, stdoutStream);
      c_fflush(stdoutStream);

      index = splitIndex;
    }
  }

  // --- Runtime Infrastructure Execution Loop ---
  function main(): number {
    const stdin_stream = get_stdin();
    const stdout_stream = get_stdout();

    const headerBuffer = c_malloc(4);
    const lengthTrackingBuffer = c_malloc(4);
    if (
      is_ptr_null(headerBuffer) === 1 || is_ptr_null(lengthTrackingBuffer) === 1
    ) return 1;

    while (true) {
      let messageBuffer = getMessage(
        stdin_stream,
        headerBuffer,
        lengthTrackingBuffer,
      );
      if (is_ptr_null(messageBuffer) === 1) break;

      let currentMessageLength = read_uint32_le(lengthTrackingBuffer);
      sendMessage(
        messageBuffer,
        currentMessageLength,
        stdout_stream,
        headerBuffer,
      );

      c_free(messageBuffer);
    }

    c_free(headerBuffer);
    c_free(lengthTrackingBuffer);
    return 0;
  }

  main();
})({});
