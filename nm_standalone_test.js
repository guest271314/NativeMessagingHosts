#!/usr/bin/env -S /home/user/bin/deno -A
// How to test the different hosts #2
// https://github.com/guest271314/NativeMessagingHosts/discussions/2
// deno -A nm_standalone_test.js /home/user/native-messaging-rust/nm_rust.rs \
//   native-messaging-extension://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/

const [path, allowed_origin] = Deno.args;

console.log({ path, allowed_origin });

const command = new Deno.Command(path, {
  args: [allowed_origin],
  stdout: "piped",
  stdin: "piped",
});

console.log(`\u001b[32mTesting ${path} Native Messaging host\u001b[0m\r\n`);

const subprocess = command.spawn();
const buffer = new ArrayBuffer(0, { maxByteLength: (1024 ** 2 * 64) });
const view = new DataView(buffer);
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

async function* getMessage(readable) {
  let messageLength = 0;
  let readOffset = 0;
  for await (let message of readable) {
    if (buffer.byteLength === 0 && messageLength === 0) {
      buffer.resize(4);
      for (let i = 0; i < 4; i++) {
        view.setUint8(i, message[i]);
      }
      messageLength = view.getUint32(0, true);
      if (messageLength === 0) {
        break;
      }
      console.log({ messageLength });

      message = message.subarray(4);
      buffer.resize(0);
    }
    if (message.length) {
      buffer.resize(buffer.byteLength + message.length);
      for (let i = 0; i < message.length; i++, readOffset++) {
        view.setUint8(readOffset, message[i]);
      }

      if (buffer.byteLength >= messageLength) {
        console.log(buffer.byteLength, messageLength);
        yield new Uint8Array(buffer);
        messageLength = 0;
        readOffset = 0;
        buffer.resize(0);
      }
    }
  }
}

let controller = void 0;

const readable = new ReadableStream({
  start(c) {
    return controller = c;
  },
});

const reader = readable.getReader();

async function echoNativeMessage(input) {
  const data = encodeMessage(input);
  if (Array.isArray(input) && input.length > 209715) {
    const totalMessageLength = input.length;
    await sendMessage(data);
    let outputLength = 0;
    while (outputLength < totalMessageLength) {
      const { value, done } = await reader.read();
      const json = value.message;
      outputLength += json.length;
      console.log({ outputLength, totalMessageLength });
      if (outputLength >= totalMessageLength) {
        break;
      }
    }
    console.log({ totalMessageLength, outputLength });
  } else {
    await sendMessage(data);
    const { value, done } = await reader.read();
    console.log(value);
  }
}

(async () => {
  try {
    for await (const message of getMessage(subprocess.stdout)) {
      const decoded = decoder.decode(message);
      const json = JSON.parse(decoded);
      controller.enqueue({
        message: json,
        jsonLength: JSON.stringify(json).length,
      });
    }
  } catch (e) {
    console.log(e.message);
    Deno.exit();
  }
})();

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
    await echoNativeMessage(message);
  }
  controller.close();
} catch (e) {
  console.log(e.stack);
  console.trace();
} finally {
  subprocess.kill("SIGTERM");
}
