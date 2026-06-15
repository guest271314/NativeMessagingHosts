// How to test the different hosts #2
// https://github.com/guest271314/NativeMessagingHosts/discussions/2
// deno -A nm_standalone_test.js /home/user/native-messaging-rust/nm_rust.rs \
//   native-messaging-extension://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/
//
// The hosts cap each *outbound* frame at 1 MiB (the host->extension Native
// Messaging limit) and split a larger response into several sub-1-MiB
// JSON-array fragments at comma boundaries, so one logical message arrives as N
// length-prefixed transport frames. getMessage() therefore treats `buffer` as a
// rolling byte queue (resizable ArrayBuffer, decoupled from stdout read
// boundaries) and echoNativeMessage() reassembles the fragments.

const [path, allowed_origin] = Deno.args;

const command = new Deno.Command(path, {
  args: [allowed_origin],
  stdout: "piped",
  stdin: "piped",
});

console.log(
  `\u001b[32mTesting ${path} Native Messaging host, allowed_origin: ${allowed_origin}\u001b[0m\r\n`,
);

const subprocess = command.spawn();
// Rolling queue. maxByteLength covers a full 64 MiB single-frame response
// (Chrome's extension->host maximum); the chunked hosts stay well under it.
const buffer = new ArrayBuffer(0, { maxByteLength: 1024 ** 2 * 64 });
const bytes = new Uint8Array(buffer); // length-tracking view for bulk copies
const view = new DataView(buffer); // length-tracking view for the length prefix
const encoder = new TextEncoder();
const decoder = new TextDecoder();

function encodeMessage(message) {
  return encoder.encode(JSON.stringify(message));
}
// Handle SpiderMonkey, concatenate "\r\n\r\n" to end of message sent for js to read message
const SPIDERMONKEY = path.includes("spidermonkey");

async function sendMessage(input, data = encodeMessage("\r\n\r\n")) {
  await new Blob([
    new Uint8Array(new Uint32Array([input.length]).buffer),
    input,
  ])
    .stream()
    .pipeTo(subprocess.stdin, { preventClose: true });
  if (SPIDERMONKEY) {
    return await new Blob([
      new Uint8Array(new Uint32Array([data.length]).buffer),
      data,
    ])
      .stream()
      .pipeTo(subprocess.stdin, { preventClose: true });
  }
}

// Yields one decoded transport frame at a time. Handles a 4-byte length prefix
// split across reads, several frames in one read, and a frame body split across
// reads, by buffering bytes until each `[length][body]` frame is complete.
async function* getMessage(readable) {
  let readOffset = 0; // bytes already consumed from the front of `buffer`
  let messageLength = -1; // current frame body length; -1 = still need the prefix
  for await (const chunk of readable) {
    // Append this read to the rolling queue.
    const base = buffer.byteLength;
    buffer.resize(base + chunk.length);
    bytes.set(chunk, base);
    // Emit every complete frame the queue now holds.
    for (;;) {
      if (messageLength < 0) {
        if (buffer.byteLength - readOffset < 4) break; // prefix incomplete
        messageLength = view.getUint32(readOffset, true);
        readOffset += 4;
      }
      if (buffer.byteLength - readOffset < messageLength) break; // body incomplete
      yield bytes.slice(readOffset, readOffset + messageLength); // copy out
      readOffset += messageLength;
      messageLength = -1;
    }
    // Drop the consumed prefix; keep the unparsed tail at the front.
    if (readOffset > 0) {
      bytes.copyWithin(0, readOffset);
      buffer.resize(buffer.byteLength - readOffset);
      readOffset = 0;
    }
  }
}

let controller = void 0;

const readable = new ReadableStream({
  start(c) {
    return (controller = c);
  },
});

const reader = readable.getReader();

async function echoNativeMessage(input) {
  const data = encodeMessage(input);
  await sendMessage(data);
  // A response > ~1 MiB returns as several [..] fragments whose elements
  // concatenate to the original array; everything else is a single frame.
  if (Array.isArray(input)) {
    const parts = [];
    let length = 0;
    do {
      const { value } = await reader.read();
      parts.push(value.message); // one parsed fragment array
      length += value.message.length;
    } while (length < input.length);
    const message = parts.flat(); // spread-free: avoids push(...bigArray) overflow
    console.log(
      message.length === input.length ? `Array(${message.length})` : message,
    );
    return message;
  }
  const { value } = await reader.read();
  console.log(value.message);
  return value.message;
}

(async () => {
  try {
    for await (const message of getMessage(subprocess.stdout)) {
      try {
        controller.enqueue({ message: JSON.parse(decoder.decode(message)) });
      } catch {
        break; // stream closed after the last message; stop enqueuing
      }
    }
  } catch (e) {
    console.log(e.message);
    Deno.exit();
  }
})();

// SpiderMonkey throws ArrayBuffer.prototype.resize: Invalid length parameter
// for Array(209715), does print full test for Array(32768)

try {
  for (const message of [
    Array(209715),
    Array(209715 * 2), // > 1 MiB: exercises the multi-frame reassembly path
    "test",
    "",
    1,
    new Uint8Array([97]),
  ]) {
    await echoNativeMessage(message);
  }
  controller.close();
} catch (e) {
  console.log(e.stack);
} finally {
  subprocess.kill("SIGTERM");
}
