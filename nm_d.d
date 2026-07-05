// D Native Messaging host
//! guest271314, QuantumSegfault (https://github.com/QuantumSegfault) 7-2-2026
//! Based on
//! https://github.com/guest271314/NativeMessagingHosts/blob/main/nm_qjs.js
//! Original hand written version
//! https://github.com/guest271314/NativeMessagingHosts/blob/main/nm_qjs_64.js
//! For native build: ldc2 -O3 nm_d.d
//! For WASI build: ldc2 -O3 -L--no-export-dynamic --checkaction=halt -betterC
//! --mtriple=wasm32-unknown-wasi --of=nm_d.wasm nm_d.d

version(WASI) {
import ldc.attributes;
import ldc.intrinsics:llvm_trap;

  /// WASI BINDINGS

  alias wasi_fd_t = int;
  enum wasi_fd_t stdin = 0;
  enum wasi_fd_t stdout = 1;
  enum wasi_fd_t stderr = 2;

  alias wasi_size_t = size_t;
  alias wasi_errno_t = ushort;

  extern(C) struct wasi_iovec_t {
    ubyte* buf;
    wasi_size_t buf_len;
  }

  extern(C) struct wasi_ciovec_t {
    const(ubyte) * buf;
    wasi_size_t buf_len;
  }

  @llvmAttr("wasm-import-module", "wasi_snapshot_preview1") @nogc nothrow {
    @llvmAttr("wasm-import-name", "fd_write") extern(C) wasi_errno_t
    wasi_fd_write(wasi_fd_t fd, wasi_ciovec_t * iovs, size_t iovs_len,
                  wasi_size_t* retptr0);

    @llvmAttr("wasm-import-name", "fd_read") extern(C) wasi_errno_t
    wasi_fd_read(wasi_fd_t fd, wasi_iovec_t * iovs, size_t iovs_len,
                 wasi_size_t* retptr0);
  }

  /// MALLOC

  extern(C) extern __gshared ubyte __heap_base;
 private
  __gshared void* heapTail = &__heap_base;

  // basic bump allocator
  // based on `malloc0` (https://github.com/muayyad-alsadi/malloc0)
  void* heapAlloc(size_t size) {
import ldc.intrinsics:llvm_wasm_memory_grow, llvm_wasm_memory_size;
    size = (size + 7) & ~7;  // align up to 8 bytes

    void* allocStart = heapTail;
    void* allocEnd = allocStart + size;

    // Pages in Wasm are 64KiB (65536)
    size_t memSizePages = llvm_wasm_memory_size(0);
    size_t memSizeBytes = memSizePages << 16;

    if (cast(size_t) allocEnd > memSizeBytes) {
      if (llvm_wasm_memory_grow(
              0, (cast(size_t) allocEnd >> 16) - memSizePages + 1) == -1)
        llvm_trap();
    }

    void* ret = allocStart;
    heapTail = allocEnd;
    return ret;
  }
  void heapFreeAll() {
    heapTail = &__heap_base;
  }

  /// RUNTIME HOOKS
  extern(C) void _d_array_slice_copy(void* dst, size_t dstlen, void* src,
                                     size_t srclen, size_t elemsz) {
import ldc.intrinsics:llvm_memcpy;

    // enforceRawArraysConformable("copy", elemsz, src[0..srclen],
    // dst[0..dstlen]);
    llvm_memcpy !size_t(dst, src, dstlen * elemsz, 0);
  }
}
else {
import std.stdio;
}

// All of these are templated (and thus emitted at the use site)
// so they work even though Phobos (stdlib) isn't linked in on Wasm/WASI
import std.algorithm:min;
import std.bitmanip:littleEndianToNative, nativeToLittleEndian;

enum uint CHUNK_SIZE = 1024 * 1024;  // 1 MiB transmission budget

// Low-level Native Messaging binary packet writer
void sendMessage(const(ubyte)[] message)
    in(message.length <= uint.max && message.length <= CHUNK_SIZE) do {
  auto len = cast(uint) message.length;
  auto lenBytes = len.nativeToLittleEndian;

  version(WASI) {
    {
      wasi_ciovec_t[1] iovecs;
      iovecs[0].buf = lenBytes.ptr;
      iovecs[0].buf_len = lenBytes.length;

      wasi_size_t written;
      auto err = stdout.wasi_fd_write(iovecs.ptr, iovecs.length, &written);
      assert(!err && written == lenBytes.length);
    }
    {
      while (message.length) {
        wasi_ciovec_t[1] iovecs;
        iovecs[0].buf = message.ptr;
        iovecs[0].buf_len = message.length;

        wasi_size_t written;
        auto err = stdout.wasi_fd_write(iovecs.ptr, iovecs.length, &written);

        assert(!err && written);
        message = message[written..$];
      }
    }
  }
  else {
    stdout.rawWrite(lenBytes);
    stdout.rawWrite(message);
    stdout.flush();
  }
}

auto trimFrontTo(T)(const(T)[] arr, in T v) {
  while (arr.length && arr[0] != v) {
    arr = arr[1.. $];
  }
  return arr;
}
auto trimBackTo(T)(const(T)[] arr, in T v) {
  while (arr.length && arr[$ - 1] != v) {
    arr = arr[0.. $ - 1];
  }
  return arr;
}
auto stripFront(T)(const(T)[] arr, in T v) {
  while (arr.length && arr[0] == v) {
    arr = arr[1.. $];
  }
  return arr;
}
auto stripBack(T)(const(T)[] arr, in T v) {
  while (arr.length && arr[$ - 1] == v) {
    arr = arr[0.. $ - 1];
  }
  return arr;
}
auto strip(T)(const(T)[] arr, in T v) => arr.stripFront(v).stripBack(v);

// Isolated streaming loop to slice massive arrays safely
void streamLargeArray(const(ubyte)[] output)
    in(output.length&& output[0] ==
       '[')  // assert we start with '[' as expected
    do {
  output = output[1.. $];  // Step past opening bracket '['

  // Step back past closing bracket ']'
  output = output.trimBackTo(']');
  if (output.length)
    output = output[0.. $ - 1];

  while (output.length) {
    // Leave a safe room margin for structural brackets
    size_t endWindow = min(CHUNK_SIZE - 4, output.length);

    auto slice = output[0..endWindow];
    if (endWindow < output.length) {
      auto trimmed = slice.trimBackTo(',');
      if (trimmed.length > 0)
        slice = trimmed;
    }

    // Only dispatch the chunk payload if it contains real JSON records
    auto strippedSlice = slice.strip(',');

    if (strippedSlice.length) {
      static ubyte[CHUNK_SIZE] chunkBuffer;  // static, so it goes in TLS rather
                                             // than on the stack
      auto chunkPayload = chunkBuffer[0..strippedSlice.length + 2];

      chunkPayload[0] = '[';
      chunkPayload[1.. $ - 1] = cast() strippedSlice;
      chunkPayload[$ - 1] = ']';
      sendMessage(chunkPayload);
    }

    // Advance processing pointer past matched delimiter tokens
    output = output[slice.length..$];
    if (output.length && output[0] == ',')
      output = output[1.. $];
  }
}

ubyte[] readStdin(ubyte[] outBuf) {
  version(WASI) {
    auto outBufRemainder = outBuf;

    wasi_size_t totalRead;
    while (outBufRemainder.length) {
      wasi_iovec_t[1] iovecs;
      iovecs[0].buf = outBufRemainder.ptr;
      iovecs[0].buf_len = outBufRemainder.length;

      wasi_size_t read;
      auto err = stdin.wasi_fd_read(iovecs.ptr, iovecs.length, &read);
      assert(!err);
      if (read == 0)
        break;

      outBufRemainder = outBufRemainder[read..$];
      totalRead += read;
    }
    return outBuf[0..totalRead];
  }
  else {
    return stdin.rawRead(outBuf);
  }
}

void echoLoop() {
  while (true) {
    ubyte[4] headerBuffer;
    auto headerChunk = readStdin(headerBuffer[]);

    if (headerChunk.length < 4) {
      break;
    }

    auto messageLength = headerBuffer.littleEndianToNative !uint;
    if (messageLength == 0)
      continue;

    version(WASI) {
      auto outputPtr = heapAlloc(messageLength);
      auto output = cast(ubyte[]) outputPtr[0..messageLength];
      scope(exit) heapFreeAll();
    }
    else auto output = new ubyte[messageLength];

    auto lenChunk = readStdin(output[]);
    if (lenChunk.length < messageLength) {
      break;
    }

    // Process inputs under the 1 MiB boundary directly
    if (messageLength <= CHUNK_SIZE) {
      sendMessage(output);
      continue;
    }

    // Process large streaming arrays exceeding 1 MiB
    if (output.length > 0 && output[0] == '[') {
      streamLargeArray(output);
      continue;
    }

    // Standard fallback envelope for unexpected massive non-array segments
    string jsonErr = `{
      "status" : "error",
      "message" : "Payload size limit breached"
    }`;
    sendMessage(cast(const ubyte[]) jsonErr);
  }
}

version(WASI) extern(C) void _start() {
  echoLoop();
}
else void main() {
  stdin.setvbuf(0, _IONBF);
  stdout.setvbuf(0, _IONBF);

  echoLoop();
}
