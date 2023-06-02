// C++ Native Messaging host
// https://browserext.github.io/native-messaging/
// https://developer.chrome.com/docs/apps/nativeMessaging/
// https://www.reddit.com/user/Eternal_Weeb/
// guest271314, 2022
#include <iostream>
#include <vector>
using namespace std;

vector<uint8_t> getMessage() {
  uint32_t length = 0;
  size_t size = fread(&length, sizeof(length), 1, stdin);
  vector<uint8_t> message(length); 
  size = fread(message.data(), sizeof(*message.data()), message.size(), stdin);
  return message;
}

void sendMessage(const vector<uint8_t> &message) {
  const uint32_t length = message.size();
  fwrite(&length, sizeof(length), 1, stdout);
  fwrite(message.data(), message.size(), sizeof(*message.data()), stdout);
  fflush(stdout);
}

int main() {
  while (true) {
    sendMessage(getMessage());
  }
  return 0;
}