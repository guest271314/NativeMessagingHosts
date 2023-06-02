#!/usr/bin/env -S ./bun run --no-install --hot
// Bun Native Messaging host
// guest271314, 10-9-2022
import {readSync} from 'node:fs';

function readFullSync(fd, buf) {
  let offset = 0;
  while (offset < buf.byteLength) {
    offset += readSync(fd, buf, { offset });
  }
  return buf;
}

function getMessage() {
  const header = new Uint32Array(1);
  readFullSync(0, header);
  const content = new Uint8Array(header[0]);
  readFullSync(0, content);
  return content;
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

function main() {
  while (true) {
    try {
      const message = getMessage();
      sendMessage(message);
    } catch (e) {
      process.exit();
    }
  }
}

main();
