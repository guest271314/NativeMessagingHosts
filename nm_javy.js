const stdin = 0;
const stdout = 1;

function encodeMessage(str) {
  return new TextEncoder().encode(JSON.stringify(str));
}

function getMessage() {
  let offset = 0;
  const header = new Uint8Array(4);
  Javy.IO.readSync(stdin, header);
  const [length] = new Uint32Array(header.buffer);
  const message = new Uint8Array(length);
  while (1) {
    const buffer = new Uint8Array(1024);
    const bytesRead = Javy.IO.readSync(stdin, buffer);
    message.set(buffer.subarray(0, bytesRead), offset);
    offset += bytesRead;
    if (offset === length) {
      break;
    }
  }
  return message;
}

function sendMessage(json) {
  let header = Uint32Array.from({
    length: 4,
  }, (_, index) => (json.length >> (index * 8)) & 0xff);
  let output = new Uint8Array(header.length + json.length);
  output.set(header, 0);
  output.set(json, 4);
  Javy.IO.writeSync(stdout, output);
}

function main() {
  while (1) {
    try {
      const message = getMessage();
      sendMessage(message);
    } catch (e) {
      sendMessage(encodeMessage(e.message));
    }
  }
}

main();
