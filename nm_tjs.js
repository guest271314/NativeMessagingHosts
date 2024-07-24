#!/usr/bin/env -S /home/user/bin/tjs run
// txiki.js Native Messaging host
// guest271314, 2-10-2023

// https://github.com/denoland/deno/discussions/17236#discussioncomment-4566134
// https://github.com/saghul/txiki.js/blob/master/src/js/core/tjs/eval-stdin.js
async function readFullAsync(length) {
  const buffer = new Uint8Array(65535);
  const data = [];
  while (data.length < length) {
    const n = await tjs.stdin.read(buffer);
    if (n === null) {
      break;
    }
    for (const value of buffer.subarray(0, n)) {
      data.push(value);
    }
  }
  return new Uint8Array(data);
}

async function getMessage() {
  const header = new Uint8Array(4);
  await tjs.stdin.read(header);
  const [length] = new Uint32Array(
    header.buffer
  );
  const output = await readFullAsync(length);
  return output;
}

async function sendMessage(message) {
  // https://stackoverflow.com/a/24777120
  const header = Uint32Array.from({
      length: 4,
    },
    (_, index) => (message.length >> (index * 8)) & 0xff
  );
  const output = new Uint8Array(header.length + message.length);
  output.set(header, 0);
  output.set(message, 4);
  await tjs.stdout.write(output);
  return true;
}

async function main() {
  try {
    while (true) {
      const message = await getMessage();
      await sendMessage(message);
    }
  } catch (e) {
    tjs.exit();
  }
}

main();
