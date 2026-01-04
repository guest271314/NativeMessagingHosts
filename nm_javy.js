const stdin = 0;
const stdout = 1;
const encoder = new TextEncoder();
const decoder = new TextDecoder();
const maxMessageLengthFromHost = 209715;

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

function sendMessage(data) {
  const json = JSON.parse(decoder.decode(data));
  if (Array.isArray(json) && json.length) {
    for (let i = 0; i < json.length; i += maxMessageLengthFromHost) {
      const message = encoder.encode(
        JSON.stringify(json.slice(i, i + maxMessageLengthFromHost)),
      );
      let header = Uint32Array.from({
        length: 4,
      }, (_, index) => (message.length >> (index * 8)) & 0xff);
      let output = new Uint8Array(header.length + message.length);
      output.set(header, 0);
      output.set(message, 4);
      Javy.IO.writeSync(stdout, output);
    }
  } else {
    let header = Uint32Array.from({
      length: 4,
    }, (_, index) => (data.length >> (index * 8)) & 0xff);
    let output = new Uint8Array(header.length + data.length);
    output.set(header, 0);
    output.set(data, 4);
    Javy.IO.writeSync(stdout, output);
  }
}

function main() {
  while (1) {
    try {
      const message = getMessage();
      sendMessage(message);
    } catch (e) {
      sendMessage(encoder.encode(JSON.stringify(e.message)));
    }
  }
}

main();
