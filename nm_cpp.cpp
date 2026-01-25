// C++ Native Messaging host
// https://browserext.github.io/native-messaging/
// https://developer.chrome.com/docs/apps/nativeMessaging/
// https://www.reddit.com/user/Eternal_Weeb/
// guest271314, 2022

/*
Can you further optimize this C++ Native Messaging host that handles 64 MiB
input that Gemini optimized from source?

I can further optimize this C++ Native Messaging host with several
improvements:## Key Optimizations:

**1. Modern C++ Features**
- Used `constexpr` for compile-time constants instead of runtime const
- Added `[[nodiscard]]` attribute to `getMessage` to catch bugs
- Used `[[likely]]` and `[[unlikely]]` branch prediction hints for better CPU
pipelining
- Changed `noexcept` specifications for better optimization potential

**2. Performance Improvements**
- Replaced manual little-endian encoding with direct write (assumes LE
architecture, which is standard)
- Used `std::memchr` instead of `std::find` for comma search (faster for
single-byte search)
- Changed `getMessage` to pass `inputLength` by reference instead of pointer
(cleaner, no null check needed)
- Modified `sendMessage` to accept `std::span` directly, eliminating redundant
pointer/length pair
- Used `resize()` instead of constructor for vector allocation (slightly more
explicit)
- Added static buffers for stdin/stdout to reduce system calls

**3. Safety Enhancements**
- Added `MAX_MESSAGE_SIZE` constant (64 MiB) to prevent malicious huge
allocations
- Added Windows binary mode support
- Better const correctness throughout

**4. Code Quality**
- Removed redundant ternary operators (`(prepend ? 1 : 0)` → `(prepend != 0)`)
- Changed `std::cin.tie(NULL)` to `nullptr` (modern C++)
- Removed manual little-endian bit manipulation (unnecessary on modern systems)
- Cleaner control flow with early returns

**5. Memory Efficiency**
- Eliminated double handling of message data by passing span directly
- Static I/O buffers avoid repeated allocations

The optimized version should handle 64 MiB messages significantly faster with
better CPU cache utilization and fewer system calls.
*/
#include <algorithm>
#include <cstdint>
#include <cstring>
#include <iostream>
#include <span>
#include <vector>

#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#endif

constexpr size_t CHUNK_SIZE = 1024 * 1024;
constexpr size_t SEARCH_WINDOW = 8;
constexpr size_t MAX_MESSAGE_SIZE = 64 * 1024 * 1024; // 64 MiB
constexpr uint8_t COMMA = ',';
constexpr uint8_t OPEN_BRACKET = '[';
constexpr uint8_t CLOSE_BRACKET = ']';

/**
 * Reads a length-prefixed message from stdin.
 * Returns a vector containing the data.
 */
[[nodiscard]] std::vector<uint8_t> getMessage(size_t &inputLength) noexcept {
  uint32_t messageLength = 0;

  // Read 4-byte header
  if (!std::cin.read(reinterpret_cast<char *>(&messageLength),
                     sizeof(uint32_t))) {
    inputLength = 0;
    return {};
  }

  // Sanity check to prevent huge allocations
  if (messageLength > MAX_MESSAGE_SIZE) {
    inputLength = 0;
    return {};
  }

  // Reserve and read payload
  std::vector<uint8_t> buffer;
  buffer.resize(messageLength);

  if (!std::cin.read(reinterpret_cast<char *>(buffer.data()), messageLength)) {
    inputLength = 0;
    return {};
  }

  inputLength = messageLength;
  return buffer;
}

/**
 * Writes a single chunk to stdout with a 4-byte Little-Endian header.
 */
inline void writeChunk(std::span<const uint8_t> body, uint8_t prepend,
                       uint8_t append) noexcept {
  const uint32_t totalLen =
      static_cast<uint32_t>(body.size() + (prepend != 0) + (append != 0));

  // Write length header directly (assume little-endian, which is standard)
  std::cout.write(reinterpret_cast<const char *>(&totalLen), sizeof(uint32_t));

  if (prepend) [[unlikely]] {
    std::cout.put(static_cast<char>(prepend));
  }

  std::cout.write(reinterpret_cast<const char *>(body.data()), body.size());

  if (append) [[unlikely]] {
    std::cout.put(static_cast<char>(append));
  }

  std::cout.flush();
}

/**
 * Splits a large message into chunks and ensures each is a valid JSON array
 * fragment.
 */
void sendMessage(std::span<const uint8_t> message) noexcept {
  if (message.empty())
    return;

  const size_t length = message.size();

  // Fast path for small messages
  if (length <= CHUNK_SIZE) {
    writeChunk(message, 0, 0);
    return;
  }

  // Chunked sending for large messages
  size_t index = 0;
  while (index < length) {
    const size_t remaining = length - index;
    size_t splitIndex = length;

    // Find comma split point if we have more data than CHUNK_SIZE
    if (remaining > CHUNK_SIZE) {
      const size_t searchStart = index + CHUNK_SIZE - SEARCH_WINDOW;
      const size_t searchLen = length - searchStart;

      // Use memchr for faster search than std::find
      const void *comma =
          std::memchr(message.data() + searchStart, COMMA, searchLen);
      if (comma) {
        splitIndex = static_cast<const uint8_t *>(comma) - message.data();
      }
    }

    std::span<const uint8_t> rawChunk =
        message.subspan(index, splitIndex - index);

    uint8_t prepend = 0;
    uint8_t append = 0;
    std::span<const uint8_t> body = rawChunk;

    const uint8_t first = rawChunk.front();
    const uint8_t last = rawChunk.back();

    // JSON wrapping logic with branch prediction hints
    if (first == OPEN_BRACKET) [[likely]] {
      if (last != CLOSE_BRACKET) {
        append = CLOSE_BRACKET;
      }-std=c++20
    } else if (first == COMMA) {
      prepend = OPEN_BRACKET;
      body = body.subspan(1); // Skip the leading comma
      if (last != CLOSE_BRACKET) {
        append = CLOSE_BRACKET;
      }
    }

    writeChunk(body, prepend, append);
    index = splitIndex;
  }
}

int main() {
// Set binary mode on Windows
#ifdef _WIN32
  _setmode(_fileno(stdin), _O_BINARY);
  _setmode(_fileno(stdout), _O_BINARY);
#endif

  // Speed up standard I/O
  std::ios_base::sync_with_stdio(false);
  std::cin.tie(nullptr);

  // Set larger buffer sizes for better I/O performance
  static char inbuf[CHUNK_SIZE];
  static char outbuf[CHUNK_SIZE];
  std::cin.rdbuf()->pubsetbuf(inbuf, sizeof(inbuf));
  std::cout.rdbuf()->pubsetbuf(outbuf, sizeof(outbuf));

  while (true) {
    size_t messageLength = 0;
    std::vector<uint8_t> message = getMessage(messageLength);

    // if (messageLength == 0) {
    //    break;
    // }

    sendMessage(message);
  }

  return 0;
}
