// How to test the different hosts #2
// https://github.com/guest271314/NativeMessagingHosts/discussions/2
// deno -A nm_standalone_test.js /home/user/native-messaging-rust/nm_rust.rs \
//   native-messaging-extension://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/

const [path, allowed_origin] = Deno.args;

const command = new Deno.Command(path, {
  args: [allowed_origin],
  stdout: "piped",
  stdin: "piped",
});

console.log(`\u001b[32mTesting ${path} Native Messaging host\u001b[0m\r\n`);

const subprocess = command.spawn();
const buffer = new ArrayBuffer(0, { maxByteLength: (1024 ** 2) });
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
      console.log({ messageLength });
      message = message.subarray(4);
      buffer.resize(0);
    }
    if (message.length) {
      buffer.resize(buffer.byteLength + message.length);
      for (let i = 0; i < message.length; i++, readOffset++) {
        view.setUint8(readOffset, message[i]);
      }
      if (buffer.byteLength === messageLength) {
        yield new Uint8Array(buffer);
        messageLength = 0;
        readOffset = 0;
        buffer.resize(0);
      }
    }
  }
}

(async () => {
  try {
    for await (const message of getMessage(subprocess.stdout)) {
      console.log(JSON.parse(decoder.decode(message)));
    }
  } catch (e) {
    console.log(e.message);
    Deno.exit();
  }
})();
// SpiderMonkey throws ArrayBuffer.prototype.resize: Invalid length parameter
// for Array(209715), does print full test for Array(32768)
let data = encodeMessage(Array(209715));

await sendMessage(data);
await new Promise((resolve) => setTimeout(resolve, 20));

data = encodeMessage("test");
await sendMessage(data);

await new Promise((resolve) => setTimeout(resolve, 20));

data = encodeMessage("");
await sendMessage(data);

await new Promise((resolve) => setTimeout(resolve, 20));

data = encodeMessage(1);
await sendMessage(data);

await new Promise((resolve) => setTimeout(resolve, 20));

data = encodeMessage(new Uint8Array([97]));
await sendMessage(data);

await new Promise((resolve) => setTimeout(resolve, 20));

subprocess.kill("SIGTERM");
