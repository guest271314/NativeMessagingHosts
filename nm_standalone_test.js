// How to test the different hosts #2 
// https://github.com/guest271314/NativeMessagingHosts/discussions/2
// deno -A nm_standalone_test.js ./nm_nodejs.js native-messaging-extension://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx/

const [path, allowed_origin] = Deno.args;

const command = new Deno.Command(path, {
  args: [allowed_origin],
  stdout: "piped",
  stdin: "piped",
});

const subprocess = command.spawn();
const buffer = new ArrayBuffer(0, { maxByteLength: 1024 ** 2 });
const view = new DataView(buffer);
const encoder = new TextEncoder();
const decoder = new TextDecoder();

function encodeMessage(message) {
  return encoder.encode(JSON.stringify(message));
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

let data = encodeMessage(Array(209715)); 

await new Blob([
  new Uint8Array(new Uint32Array([data.length]).buffer),
  data,
])
  .stream()
  .pipeTo(subprocess.stdin, { preventClose: true });

await new Promise((resolve) => setTimeout(resolve, 20));

data = encodeMessage("test");
await new Blob([
  new Uint8Array(new Uint32Array([data.length]).buffer),
  data,
])
  .stream()
  .pipeTo(subprocess.stdin, { preventClose: true });

await new Promise((resolve) => setTimeout(resolve, 20));

data = encodeMessage("");
await new Blob([
  new Uint8Array(new Uint32Array([data.length]).buffer),
  data,
])
  .stream()
  .pipeTo(subprocess.stdin, { preventClose: true });

await new Promise((resolve) => setTimeout(resolve, 20));

data = encodeMessage(1);
await new Blob([
  new Uint8Array(new Uint32Array([data.length]).buffer),
  data,
])
  .stream()
  .pipeTo(subprocess.stdin, { preventClose: true });

await new Promise((resolve) => setTimeout(resolve, 20));

data = encodeMessage(new Uint8Array([97]));
await new Blob([
  new Uint8Array(new Uint32Array([data.length]).buffer),
  data,
])
  .stream()
  .pipeTo(subprocess.stdin, { preventClose: true});

await new Promise((resolve) => setTimeout(resolve, 20));

subprocess.kill("SIGTERM");
