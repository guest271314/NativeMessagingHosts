#!/usr/bin/env -S ./deno run --v8-flags="--expose-gc,--jitless"
// Deno Native Messaging host
// guest271314, 10-5-2022

// https://github.com/denoland/deno/discussions/17236#discussioncomment-4566134
// https://github.com/saghul/txiki.js/blob/master/src/js/core/tjs/eval-stdin.js
async function readFullAsync(length) {
  const buffer = new Uint8Array(65536);
  const data = [];
  let n = null;
  while (data.length < length && (n = await Deno.stdin.read(buffer))) {
    data.push(...buffer.subarray(0, n));
  }
  return new Uint8Array(data);
}

async function getMessage() {
  const header = new Uint32Array(1);
  await Deno.stdin.read(new Uint8Array(header.buffer));
  return readFullAsync(header[0]);
}

async function sendMessage(message) {
  const header = new Uint32Array([message.length]);
  await Deno.stdout.write(new Uint8Array(header.buffer));
  await Deno.stdout.write(message);
}

async function main() {
  while (true) {
    const message = await getMessage();
    await sendMessage(message);
    gc();
  }
}

try {
  main();
} catch (e) {
  Deno.exit();
}
