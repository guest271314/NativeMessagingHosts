// Static Hermes Native Messaging inline functions
// guest271314 10-3-2016

#ifndef NM_SHERMES_H
#define NM_SHERMES_H

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
