// Native Messaging host C
// https://stackoverflow.com/q/64400254
// https://gist.github.com/zed/4459378be67a4b37f53430e0703cb700
// https://www.reddit.com/r/C_Programming/comments/y4omt0/how_to_fix_memory_leak/
// guest271314, 2022
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
// Parameter `inputLength`: a pointer to a single `size_t` variable. 
// `size_t` is an unsigned integer type big enough to represent the length of any 
// memory sequence, it's usually 8 bytes.
//
// Return value: a pointer to a buffer of bytes. `uint8_t` is an unsigned 8-bit 
// integer (value range is from 0 to 255).
uint8_t* getMessage(size_t *inputLength) {
  // Read the first 4 bytes (32 bits) into the memory allocated for the variable 
  // `inputLength`. 
  uint32_t messageLength = 0;
  // The operator `&` gives a pointer to the variable, so `fread()` writes directly
  // into `inputLength`. 
  size_t result = fread(&messageLength, sizeof(messageLength), 1, stdin);
  // Allocate a buffer that is 'messageLength' elements long. `calloc() and 
  // `malloc()` return a pointer to memory on the heap.
  // The operator `*` dereferences a pointer (`*message' is equivalent to 
  // `message[0]`).
  // `sizeof(*message)` will hence return the size in bytes of the type 
  // `message` points at, which means it's equivalent to `sizeof(uint_8)`.
  // To ensure that the message ends with a null terminator
  // rather than whatever garbage is left over after the allocated buffer add
  // 1 to the message length when allocating the message buffer.
  uint8_t *message = calloc(messageLength+1, sizeof(*message));
  result = fread(message, sizeof(*message), messageLength, stdin);
  // `inputLength` is a pointer, so we store the length at the memory address it 
  // points at. This way we return 2 values at once from a function!
  *inputLength = messageLength;
  return message;
}

void sendMessage(uint8_t *response /*, int32_t responseLength */) {
  const uint32_t responseLength = strlen((const char *)response);
  fwrite(&responseLength, sizeof responseLength, 1, stdout);
  fwrite(response, responseLength, 1, stdout);
  fflush(stdout);
}

int main(void) {
  while (1) {
    // `messageLength`: Variable to store the message's length.
    // We pass the address of 'messageLength' to the function, and `message` 
    // stores the allocated buffer which we have to `free()`.
    size_t messageLength = 0;
    uint8_t *const message = getMessage(&messageLength);
    // Do things with `message`, but don't change the pointer value, for 
    // example:
    // message[5] = 'a'; // Ok, pointer still points to start of message.
    // message = NULL; // Bad! Now we can't `free()` the message.
    sendMessage(message /*, messageLength */);
    free(message);
  }
}
