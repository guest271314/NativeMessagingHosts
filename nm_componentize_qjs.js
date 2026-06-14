//! componentize-qjs Native Messaging host
//! guest271314, andreiltd (https://github.com/andreiltd), 6-13-2026
//! https://github.com/andreiltd/issues/1
//! Based on https://github.com/guest271314/native-messaging-webassembly/nm_javy.js

import stdin from "wasi:cli/stdin@0.2.10";
import stdout from "wasi:cli/stdout@0.2.10";
import streams from "wasi:io/streams@0.2.10";

const WRITE_CHUNK = 4096;
const FRAME = 1024 * 1024;
const COMMA = 0x2c, OPEN = 0x5b, CLOSE = 0x5d;

function unwrap(r) {
  if (r.tag === "err") throw new Error("stream error");
  return r.val;
}

function readExact(input, n) {
  const out = new Uint8Array(n);
  let off = 0;
  while (off < n) {
    const r = streams.methodInputStreamBlockingRead(input, n - off);
    if (r.tag === "err") {
      if (r.val.tag === 1) return null;
      throw new Error("read");
    }
    out.set(r.val, off);
    off += r.val.length;
  }
  return out;
}

function readMessage(input) {
  const header = readExact(input, 4);
  if (header === null) return null;
  const len = new DataView(header.buffer).getUint32(0, true);
  return len === 0 ? new Uint8Array(0) : readExact(input, len);
}

function writeAll(output, data) {
  for (let off = 0; off < data.length; off += WRITE_CHUNK) {
    unwrap(
      streams.methodOutputStreamBlockingWriteAndFlush(
        output,
        data.subarray(off, off + WRITE_CHUNK),
      ),
    );
  }
}

function writeFrame(output, body) {
  const frame = new Uint8Array(4 + body.length);
  new DataView(frame.buffer).setUint32(0, body.length, true);
  frame.set(body, 4);
  writeAll(output, frame);
}

function sendMessage(output, msg) {
  if (msg.length <= FRAME) {
    writeFrame(output, msg);
    return;
  }
  for (let i = 1, end = msg.length - 1; i < end;) {
    let j = i + FRAME - 16;
    if (j >= end) j = end;
    else {
      const c = msg.indexOf(COMMA, j);
      j = c === -1 ? end : c;
    }
    const body = new Uint8Array(2 + (j - i));
    body[0] = OPEN;
    body.set(msg.subarray(i, j), 1);
    body[body.length - 1] = CLOSE;
    writeFrame(output, body);
    i = j + 1;
  }
}

export const run = {
  run() {
    const input = stdin.getStdin();
    const output = stdout.getStdout();
    for (let msg; (msg = readMessage(input)) !== null;) {
      sendMessage(output, msg);
    }
    return { tag: "ok" };
  },
};
