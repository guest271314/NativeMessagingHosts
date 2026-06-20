#!/usr/bin/env -S UV_THREADPOOL_SIZE=1 /home/user/bin/node --expose-gc --memory-saver-mode --v8-pool-size=1 --jitless --zero-unused-memory
// How to test the different hosts #2
// https://github.com/guest271314/NativeMessagingHosts/discussions/2
// node nm_standalone_test_node.js /home/user/native-messaging-rust/nm_rust.rs \
//   native-messaging-extension://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/

import { spawn } from "node:child_process";

const hostPath = process.argv.at(-1);
const encoder = new TextEncoder();
const decoder = new TextDecoder();

const subprocess = spawn(hostPath, [], {
  stdio: ["pipe", "pipe", "pipe"],
});

console.log(`\u001b[32mTesting ${hostPath} Native Messaging host\u001b[0m\r\n`);

function encodeMessage(message) {
  return encoder.encode(JSON.stringify(message));
}

async function readNativeMessage() {
  const buffer = new ArrayBuffer(0, {
    maxByteLength: 1024 ** 2 * 64,
  });
  const { resolve, promise } = Promise.withResolvers();
  let bytesRead = 0;
  let offset = 0;
  let messageLength = 0;
  function read() {
    if (messageLength === 0) {
      const header = new Uint8Array(4);
      const headerBuffer = subprocess.stdout.read(4);
      header.set(headerBuffer, 0);
      messageLength = header[0] + header[1] * 256 + header[2] * 65536 +
        header[3] * 16777216;
      console.log({ messageLength });
    }
    while (messageLength > 0 && bytesRead < messageLength) {
      const data = subprocess.stdout.read(messageLength);
      if (data === null) {
        break;
      }
      bytesRead += data.length;
      buffer.resize(buffer.byteLength + data.length);
      new Uint8Array(buffer, offset++).set(data);
      if (bytesRead === messageLength) {
        subprocess.stdout.removeListener("readable", read);
        const json = JSON.parse(decoder.decode(new Uint8Array(buffer)));
        resolve(json);
        buffer.resize(0);
        bytesRead = 0;
        offset = 0;
        messageLength = 0;
        break;
      }
    }
  }

  subprocess.stdout.on("readable", read);
  return promise;
}

async function echoNativeMessage(input) {
  const message = encodeMessage(input);
  const messageLength = message.length;
  const inputLength = input.length;
  const header = new Uint8Array([
    messageLength & 255,
    messageLength >> 8 & 255,
    messageLength >> 16 & 255,
    messageLength >> 24 & 255,
  ]);
  const data = new Uint8Array(header.length + messageLength);
  let outputLength = 0;
  data.set(header, 0);
  data.set(message, 4);
  if (!subprocess.stdin.write(data)) {
    await new Promise((resolve) => subprocess.stdin.once("drain", resolve));
  }
  while (true) {
    const result = await readNativeMessage();
    if (result === null) {
      break;
    }
    console.log({ message: result });
    if (Array.isArray(input) && inputLength > 209715) {
      outputLength += result.length;
      if (outputLength === inputLength) {
        return { inputLength, outputLength };
      }
    } else {
      outputLength = JSON.stringify(result).length;
      return { inputLength: JSON.stringify(input).length, outputLength };
    }
  }
}

try {
  for (
    const message of [
      Array(209715),
      "test",
      "",
      1,
      new Uint8Array([97]),
      Array(209715 * 64),
    ]
  ) {
    const result = await echoNativeMessage(message);
    console.log(result);
  }
} catch (e) {
  console.log(e.stack);
  console.trace();
} finally {
  subprocess.kill("SIGTERM");
}
