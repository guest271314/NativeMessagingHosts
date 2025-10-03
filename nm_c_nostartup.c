// C Native Messaging host
// -nostartupfiles for shermes compilation
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
uint8_t* getMessage(size_t *inputLength) {
  uint32_t messageLength = 0;
  size_t result = fread(&messageLength, sizeof(messageLength), 1, stdin);
  uint8_t *message = calloc(messageLength+1, sizeof(*message));
  result = fread(message, sizeof(*message), messageLength, stdin);
  *inputLength = messageLength;
  return message;
}

void sendMessage(uint8_t *response) {
  const uint32_t responseLength = strlen(response);
  fwrite(&responseLength, sizeof responseLength, 1, stdout);
  fwrite(response, responseLength, 1, stdout);
  fflush(stdout);
}

int nativeMessagingHost(void) {
  while (1) {
    size_t messageLength = 0;
    uint8_t *const message = getMessage(&messageLength);
    sendMessage(message);
    free(message);
  }
}

int _start() {
  exit(nativeMessagingHost());
}
