#!/usr/bin/env -S UV_THREADPOOL_SIZE=1 /home/user/bin/node --optimize-for-size --zero-unused-memory --memory-saver-mode --double-string-cache-size=1 --experimental-flush-embedded-blob-icache --jitless --expose-gc --v8-pool-size=1
// Node.js Native Messaging host
// guest271314, 10-9-2022

// try {port.postMessage(Array((209715*65)))} catch (e) {console.log(e)}
// Error: Message exceeded maximum allowed size of 64MiB.
const maxMessageLengthFromHost = 209715;
let currentMessageLength = 0;
const encoder = new TextEncoder();
const decoder = new TextDecoder();
const data = Array();
// https://github.com/nodejs/node/issues/11568#issuecomment-282765300
process.stdout._handle.setBlocking(false);

for await (const nativeMessage of process.stdin) {
  if (currentMessageLength === 0 && data.length === 0) {
    const u8 = new Uint8Array(nativeMessage);
    currentMessageLength = new DataView(u8.subarray(0, 4).buffer).getUint32(
      0,
      true,
    );
    data.push(...u8.subarray(4));
  } else {
    if (data.length < currentMessageLength) {
      const u8 = new Uint8Array(nativeMessage);
      data.push(...u8);
    }
  }
  if (data.length && data.length === currentMessageLength) {
    const json = JSON.parse(decoder.decode(new Uint8Array(data)));
    if (Array.isArray(json) && json.length) {
      for (let i = 0; i < json.length; i += maxMessageLengthFromHost) {
        const message = encoder.encode(
          JSON.stringify(json.slice(i, i + maxMessageLengthFromHost)),
        );
        process.stdout.write(new Uint32Array([message.length]));
        process.stdout.write(message);
      }
      await new Promise((resolve) => {
        process.stdout.once("drain", resolve);
      });
      currentMessageLength = 0;
      data.length = 0;
      gc();
      continue;
    } else {
      const message = encoder.encode(
        JSON.stringify(json),
      );
      process.stdout.write(new Uint32Array([message.length]));
      process.stdout.write(message);
    }
    currentMessageLength = 0;
    data.length = 0;
    gc();
    continue;
  }
}
