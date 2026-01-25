// Native Messaging host C
// https://stackoverflow.com/q/64400254
// https://gist.github.com/zed/4459378be67a4b37f53430e0703cb700
// https://www.reddit.com/r/C_Programming/comments/y4omt0/how_to_fix_memory_leak/
// guest271314, 2022

// https://claude.ai/chat/c5f17e04-09a3-43c2-aabb-c9dba6a540f3
/*
Can you further optimize this C Native Messaging host that handles 64 MiB input
that Gemini optimized from source?

I can optimize this Native Messaging host further. Here are several
improvements:

## Key Optimizations:
**1. Memory Allocation**
- Changed `calloc` to `malloc` in `getMessage` since we're immediately reading
into the buffer anyway (no need to zero-initialize)
- Added explicit null termination instead of relying on calloc's zeroing

**2. Performance Improvements**
- Made functions `static inline` for potential compiler inlining
- Reduced redundant calculations and variable assignments
- Simplified branching logic in `sendMessage`
- Changed `has_prepend`/`has_append` from ints to uint8_t (smaller, more
cache-friendly)
- Used `const` pointers where appropriate to help compiler optimizations

**3. I/O Optimization**
- Added large I/O buffers (`setvbuf`) to reduce system calls
- Combined write operations where possible

**4. Safety Enhancements**
- Added 64 MiB sanity check to prevent malicious huge allocations
- Added Windows binary mode support
- Improved const correctness

**5. Code Clarity**
- Defined `SEARCH_WINDOW` constant instead of magic number 8
- Simplified variable names and reduced temporary variables
- More compact JSON framing logic

The optimized version should handle 64 MiB messages more efficiently with better
memory usage and fewer system calls.
*/
// Native Messaging host C - Optimized
// https://stackoverflow.com/q/64400254
// https://gist.github.com/zed/4459378be67a4b37f53430e0703cb700
// https://www.reddit.com/r/C_Programming/comments/y4omt0/how_to_fix_memory_leak/
// guest271314, 2022
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define CHUNK_SIZE (1024 * 1024)
#define SEARCH_WINDOW 8

// Optimized getMessage with error checking
static inline uint8_t *getMessage(size_t *inputLength) {
  uint32_t messageLength;

  // Read the 4-byte header in one call
  if (fread(&messageLength, sizeof(uint32_t), 1, stdin) != 1) {
    *inputLength = 0;
    return NULL;
  }

  // Sanity check to prevent huge allocations
  if (messageLength > (64 << 20)) { // 64 MiB limit
    *inputLength = 0;
    return NULL;
  }

  // Allocate buffer (use malloc instead of calloc - we're reading into it
  // anyway)
  uint8_t *message = (uint8_t *)malloc(messageLength + 1);
  if (!message) {
    *inputLength = 0;
    return NULL;
  }

  // Read the payload
  size_t bytesRead = fread(message, 1, messageLength, stdin);
  message[bytesRead] = '\0'; // Null terminate

  *inputLength = bytesRead;
  return message;
}

// Optimized sendMessage with reduced branching
static void sendMessage(const uint8_t *message, size_t length) {
  if (!message || length == 0)
    return;

  // Fast path for small messages
  if (length <= CHUNK_SIZE) {
    uint32_t len32 = (uint32_t)length;
    fwrite(&len32, sizeof(uint32_t), 1, stdout);
    fwrite(message, 1, length, stdout);
    fflush(stdout);
    return;
  }

  // Chunked sending for large messages
  size_t index = 0;
  while (index < length) {
    size_t remaining = length - index;
    size_t split_index = length;

    // Find comma split point if we have more data than CHUNK_SIZE
    if (remaining > CHUNK_SIZE) {
      size_t search_start = index + CHUNK_SIZE - SEARCH_WINDOW;
      const uint8_t *search_ptr = message + search_start;
      size_t search_len = length - search_start;

      const uint8_t *comma_ptr =
          (const uint8_t *)memchr(search_ptr, ',', search_len);
      if (comma_ptr) {
        split_index = comma_ptr - message;
      }
    }

    const uint8_t *chunk_start = message + index;
    size_t chunk_len = split_index - index;

    // Determine JSON framing needs
    uint8_t first = chunk_start[0];
    uint8_t last = chunk_start[chunk_len - 1];

    const uint8_t *body = chunk_start;
    size_t body_len = chunk_len;
    uint8_t prepend = 0, append = 0;

    if (first == '[') {
      if (last != ']')
        append = ']';
    } else if (first == ',') {
      prepend = '[';
      body++;
      body_len--;
      if (last != ']')
        append = ']';
    }

    // Write chunk with length header
    uint32_t total_len =
        (uint32_t)(body_len + (prepend ? 1 : 0) + (append ? 1 : 0));
    fwrite(&total_len, sizeof(uint32_t), 1, stdout);

    if (prepend)
      fputc(prepend, stdout);
    fwrite(body, 1, body_len, stdout);
    if (append)
      fputc(append, stdout);

    fflush(stdout);
    index = split_index;
  }
}

int main(void) {
// Set binary mode on Windows
#ifdef _WIN32
  _setmode(_fileno(stdin), _O_BINARY);
  _setmode(_fileno(stdout), _O_BINARY);
#endif

  // Increase buffer sizes for better I/O performance
  setvbuf(stdin, NULL, _IOFBF, CHUNK_SIZE);
  setvbuf(stdout, NULL, _IOFBF, CHUNK_SIZE);

  while (1) {
    size_t messageLength = 0;
    uint8_t *message = getMessage(&messageLength);

    // if (!message)
    //  break;

    sendMessage(message, messageLength);
    free(message);
  }

  return 0;
}
