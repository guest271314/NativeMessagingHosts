// Static Hermes Native Messaging host inline functions
// guest271314 10-3-2026

#ifndef NM_SHERMES_H
#define NM_SHERMES_H

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#ifndef _WIN32
#include <unistd.h>
#endif

#ifdef _WIN32
#include <fcntl.h>
#include <io.h>
#endif

#define CHUNK_SIZE (1024 * 1024)

static inline void* get_c_stdin() {
  return (void*)stdin;
}
static inline void* get_c_stdout() {
  return (void*)stdout;
}

static inline void init_binary_io() {
  setvbuf(stdin, NULL, _IOFBF, CHUNK_SIZE);
  setvbuf(stdout, NULL, _IOFBF, CHUNK_SIZE);
#ifdef _WIN32
  _setmode(_fileno(stdin), _O_BINARY);
  _setmode(_fileno(stdout), _O_BINARY);
#endif
}

static inline int c_read_uint32_le(void* ptr) {
  uint32_t val;
  memcpy(&val, ptr, 4);
  return (int)val;
}

static inline void c_write_uint32_le(void* ptr, int val) {
  uint32_t clean_val = (uint32_t)val;
  memcpy(ptr, &clean_val, 4);
}

static inline int c_get_byte(void* ptr, size_t offset) {
  return (int)((uint8_t*)ptr)[offset];
}

static inline void c_set_byte(void* ptr, size_t offset, int value) {
  ((uint8_t*)ptr)[offset] = (uint8_t)value;
}

static inline void* c_memchr(void* ptr, int ch, size_t out_len) {
  return memchr(ptr, ch, out_len);
}

static inline void* c_ptr_add(void* ptr, size_t offset) {
  return (void*)((uint8_t*)ptr + offset);
}

static inline size_t c_ptr_diff(void* ptr1, void* ptr2) {
  return (size_t)((uint8_t*)ptr1 - (uint8_t*)ptr2);
}

static inline void* c_null_ptr() {
  return NULL;
}

static inline int c_is_null(void* ptr) {
  return ptr == NULL ? 1 : 0;
}

static inline int c_read_fd(int fd, void* base, size_t offset, size_t len) {
  uint8_t* p = (uint8_t*)base + offset;
  for (;;) {
#ifdef _WIN32
    int n = _read(fd, p, (unsigned int)len);
#else
    ssize_t n = read(fd, p, len);
#endif
    if (n < 0 && errno == EINTR) continue;
    return (int)n;
  }
}

static inline int c_write_fd(int fd, void* base, size_t offset, size_t len) {
  uint8_t* p = (uint8_t*)base + offset;
  for (;;) {
#ifdef _WIN32
    int n = _write(fd, p, (unsigned int)len);
#else
    ssize_t n = write(fd, p, len);
#endif
    if (n < 0 && errno == EINTR) continue;
    return (int)n;
  }
}

static inline void c_copy(void* dst, size_t dst_off, void* src, size_t src_off, size_t n) {
  memcpy((uint8_t*)dst + dst_off, (uint8_t*)src + src_off, n);
}

// Regions may overlap (the window shift in streamIncomingMessage), so this must be memmove.
static inline void c_move(void* dst, size_t dst_off, void* src, size_t src_off, size_t n) {
  memmove((uint8_t*)dst + dst_off, (uint8_t*)src + src_off, n);
}

// Index of the first `ch` in [start, end), or -1.
static inline int c_index_of(void* base, size_t start, size_t end, int ch) {
  if (start >= end) return -1;
  uint8_t* p = (uint8_t*)memchr((uint8_t*)base + start, ch, end - start);
  return p == NULL ? -1 : (int)(p - (uint8_t*)base);
}

extern int main(int argc, char** argv);

int __libc_start_main(int (*main_func)(int, char**, char**),
                      int argc,
                      char** argv,
                      void (*init)(void),
                      void (*fini)(void),
                      void (*rtld_fini)(void),
                      void* stack_end) {
  init_binary_io();

  // Keep argc at 1, and pass the existing argv.
  int clean_argc = 1;

  int status = main(clean_argc, argv);
  exit(status);
}

#endif
