#!/usr/bin/env -S ./node --jitless --expose-gc --v8-pool-size=1
// Node.js Native Messaging host
// guest271314, 10-9-2022
import { open } from "node:fs/promises";
process.env.UV_THREADPOOL_SIZE = 1;

// https://github.com/denoland/deno/discussions/17236#discussioncomment-4566134
// https://github.com/saghul/txiki.js/blob/master/src/js/core/tjs/eval-stdin.js
async function readFullAsync(length, buffer = new Uint8Array(65536)) {
  const data = [];
  while (data.length < length) {
    const input = await open("/dev/stdin");
    let { bytesRead } = await input.read({
      buffer
    });
    await input.close();
    if (bytesRead === 0) {
      break;
    }
    data.push(...buffer.subarray(0, bytesRead));  
  }
  return new Uint8Array(data);
}

async function getMessage() {
  const header = new Uint32Array(1);
  await readFullAsync(1, header);
  const content = await readFullAsync(header[0]);
  return content;
}

async function sendMessage(message) {
  const header = new Uint32Array([message.length]);
  const stdout = await open("/proc/self/fd/1", "w");
  await stdout.write(header);
  await stdout.write(message);
  await stdout.close();
  global.gc();
}

async function main() {
  while (true) {
    try {
      const message = await getMessage();
      await sendMessage(message);
    } catch (e) {
      process.exit();
    }
  }
}

main();
