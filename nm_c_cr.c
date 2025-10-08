// https://codereview.stackexchange.com/a/298284
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const uint32_t max_message_size = 64 * 1024 * 1024;

/**
 * Get a message in Chrome's native messaging format
 *
 * @return A pointer to the message if succesful, `NULL` otherwise.
 *         The caller is responsible for freeing the message using
 *         free().
 */
char* getMessage(void) {
  // Read the size of the message
  uint32_t size;
  size_t result = fread(&size, sizeof size, 1, stdin);
  if (result != 1) {
    return NULL;
  }

  // Check if the size is valid
  if (size > max_message_size) {
    return NULL;
  }

  // Allocate memory for the message and the terminating NUL-byte
  char *message = malloc(size + 1);
  if (!message) {
    return NULL;
  }

  // Read the message itself
  result = fread(message, size, 1, stdin);
  if (result != 1) {
    free(message);
    return NULL;
  }

  // Ensure the message is NUL-terminated
  message[size] = '\0';
  return message;
}

/**
 * Send a message in Chrome's native messaging format
 *
 * @param message A pointer to the message.
                  It must be a NUL-terminated string.
 * @return        `true` if the message was sent succesfully,
                  `false` otherwise.
 */
bool sendMessage(const char* message) {
  // Write the size of the message
  const uint32_t size = strlen(message);
  if (fwrite(&size, sizeof size, 1, stdout) != 1) {
      return false;
  }

  // Write the message itself
  if (fwrite(message, size, 1, stdout) != 1) {
      return false;
  }

  // Flush the output to ensure the message is sent completely
  return fflush(stdout) == 0;
}

int main(void) {
  while (true) {
    char* message = getMessage();
    if (!message) {
      perror("Could not read message");
      return EXIT_FAILURE;
    }

    bool sent = sendMessage(message);
    free(message);

    if (!sent) {
      perror("Could not send message");
      return EXIT_FAILURE;
    }
  }
}
