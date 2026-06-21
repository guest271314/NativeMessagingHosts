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

// Persistent flowing reader + length-prefix deframer. ONE 'data' handler is
// attached up front (not per-call), so stdout always drains concurrently with
// stdin writes. Paused-mode `read(n)` stalls when n exceeds the stream's
// highWaterMark (a re-chunk frame is ~1 MiB), and a reader attached only after
// the write deadlocks large inputs — both avoided here. Frames are buffered and
// clipped to exactly the declared length, so a read that straddles a frame
// boundary never bleeds the next header into the current body.
let stdoutBuffer = Buffer.alloc(0);
let frameNeed = -1; // -1 = awaiting 4-byte header; >= 0 = awaiting that many body bytes
const frameQueue = []; // parsed frames not yet consumed by a reader
const frameWaiters = []; // pending readNativeMessage() resolvers

subprocess.stdout.on("data", (chunk) => {
  stdoutBuffer = Buffer.concat([stdoutBuffer, chunk]);
  while (true) {
    if (frameNeed < 0) {
      if (stdoutBuffer.length < 4) break;
      frameNeed = stdoutBuffer.readUInt32LE(0);
      stdoutBuffer = stdoutBuffer.subarray(4);
      console.log({ messageLength: frameNeed });
    }
    if (stdoutBuffer.length < frameNeed) break; // wait for the full frame body
    const body = stdoutBuffer.subarray(0, frameNeed);
    stdoutBuffer = stdoutBuffer.subarray(frameNeed);
    frameNeed = -1;
    const json = JSON.parse(decoder.decode(body));
    if (frameWaiters.length > 0) {
      frameWaiters.shift()(json);
    } else {
      frameQueue.push(json);
    }
  }
});

subprocess.stdout.on("end", () => {
  while (frameWaiters.length > 0) frameWaiters.shift()(null);
});

function readNativeMessage() {
  if (frameQueue.length > 0) {
    return Promise.resolve(frameQueue.shift());
  }
  return new Promise((resolve) => frameWaiters.push(resolve));
}

async function echoNativeMessage(input) {
  const message = encodeMessage(input);
  const messageLength = message.length;
  const inputLength = input.length;
  const header = new Uint8Array([
    messageLength & 255,
    (messageLength >> 8) & 255,
    (messageLength >> 16) & 255,
    (messageLength >> 24) & 255,
  ]);
  const data = new Uint8Array(header.length + messageLength);
  let outputLength = 0;
  data.set(header, 0);
  data.set(message, 4);
  // Attach the stdout reader BEFORE writing stdin so output drains
  // concurrently. Otherwise large inputs deadlock: the host interleaves stdin
  // reads and stdout writes; once the 64 KB stdout pipe fills, the host blocks
  // on write and stops draining stdin, so 'drain' never fires and the reader is
  // never attached.
  let pending = readNativeMessage();
  if (!subprocess.stdin.write(data)) {
    await new Promise((resolve) => subprocess.stdin.once("drain", resolve));
  }
  while (true) {
    const result = await pending;
    if (result === null) {
      break;
    }
    console.log({ message: result });
    if (Array.isArray(input) && inputLength > 209715) {
      outputLength += result.length;
      if (outputLength === inputLength) {
        return { inputLength, outputLength };
      }
      pending = readNativeMessage();
    } else {
      outputLength = JSON.stringify(result).length;
      return { inputLength: JSON.stringify(input).length, outputLength };
    }
  }
}

try {
  for (const message of [
    Array(209715),
    "test",
    "",
    1,
    new Uint8Array([97]),
    Array(209715 * 64),
  ]) {
    const result = await echoNativeMessage(message);
    console.log(result);
  }
} catch (e) {
  console.log(e.stack);
  console.trace();
} finally {
  subprocess.kill("SIGTERM");
}
