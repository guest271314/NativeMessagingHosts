#!/usr/bin/env -S ./bun run --no-install --hot
// Bun Native Messaging host
// guest271314, 10-9-2022
async function getMessage() {
  const { promise, resolve } = Promise.withResolvers();
  // https://github.com/simov/native-messaging/blob/8e99d2a345ae94426a502d05aa5d57b966f6bc78/protocol.js
  let messageLength = 0,
    bytesWritten = 0,
    input = [];

  process.stdin.on("readable", () => {
    let chunk;
    while ((chunk = process.stdin.read())) {
      // Set message value length once
      if (messageLength === 0) {
        [messageLength] = new Uint32Array(chunk.buffer.slice(0, 4));
        chunk = chunk.subarray(4);
      }
      // Store accrued message length read
      bytesWritten += chunk.length;
      input.push(...chunk);
      if (bytesWritten === messageLength) {
        // Send accrued message from client back to client
        resolve(new Uint8Array(input));
      }
    }
  });

  return await promise;
}

function sendMessage(json) {
  // https://github.com/denoland/deno/discussions/17236#discussioncomment-4566134
  const header = new Uint32Array([json.length]);
  /*
  // Long form
  const header = new Uint32Array([
    ((uint32) =>     
      // https://stackoverflow.com/a/58288413
      (uint32[3] << 24) 
      | (uint32[2] << 16) 
      | (uint32[1] << 8) 
      | (uint32[0])
      )(Array.from({
        length: 4,
      }, (_,index)=>(json.length >> (index * 8)) & 0xff)
    )
  ]);
  */
  process.stdout.write(new Uint8Array(header.buffer));
  process.stdout.write(json);
  Bun.gc(true);
}

async function main() {
  while (true) {
    try {
      const message = await getMessage();
      sendMessage(message);
    } catch (e) {
      process.exit();
    }
  }
}

main();
