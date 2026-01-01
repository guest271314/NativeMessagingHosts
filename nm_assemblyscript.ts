const maxMessageLengthFromHost: i32 = 209715;

function getMessage(): ArrayBuffer {
  const header = new ArrayBuffer(4);
  process.stdin.read(header);
  const headerView = new DataView(header);
  const messageLength: i32 = headerView.getUint32(0, true);
  const messageBuffer = new ArrayBuffer(messageLength);
  let offset: i32 = 0;
  while (offset < messageLength) {
    const currentBufferLength: i32 = process.stdin.read(messageBuffer, offset);
    offset += currentBufferLength;
  }
  return messageBuffer;
}

function sendMessage(messageBuffer: ArrayBuffer): void {
  const json = Uint8Array.wrap(messageBuffer);
  if (json[0] === 91 && messageBuffer.byteLength > 1024 ** 2) {
    const data = new Array<Uint8Array>();
    let fromIndex: i32 = (1024 ** 2) - 8;
    let index: i32 = 0;
    let i: i32 = 0;
    do {
      i = json.indexOf(44, fromIndex);
      const arr = json.subarray(index, i);
      data.push(arr);
      index = i;
      fromIndex += 1024 ** 2 - 8;
    } while (fromIndex < json.length);
    if (index < json.length) {
      data.push(json.subarray(index));
    }
    for (let j: i32 = 0; j < data.length; j++) {
      const start = data[j][0];
      const end = data[j][data[j].length - 1];
      if (start === 91 && end !== 44 && end !== 93) {
        const x = new Uint8Array(data[j].length + 1);
        for (let i = 0; i < data[j].length; i++) {
          x[i] = data[j][i];
        }
        x[x.length - 1] = 93;
        data[j] = x;
      }
      if (start === 44 && end !== 93) {
        const x = new Uint8Array(data[j].length + 1);
        x[0] = 91;
        for (let i = 1; i < data[j].length; i++) {
          x[i] = data[j][i];
        }
        x[x.length - 1] = 93;
        data[j] = x;
      }
      if (start === 44 && end === 93) {
        const x = new Uint8Array(data[j].length);
        x[0] = 91;
        for (let i = 1; i < data[j].length; i++) {
          x[i] = data[j][i];
        }
        data[j] = x;
      }
    }
    for (let k: i32 = 0; k < data.length; k++) {
      const message = data[k].buffer;
      const messageBufferHeader = new ArrayBuffer(4);
      new DataView(messageBufferHeader).setUint32(
        0,
        message.byteLength,
        true,
      );
      process.stdout.write(messageBufferHeader);
      process.stdout.write(message);
    }
  } else {
    const messageBufferHeader = new ArrayBuffer(4);
    new DataView(messageBufferHeader).setUint32(
      0,
      messageBuffer.byteLength,
      true,
    );
    process.stdout.write(messageBufferHeader);
    process.stdout.write(messageBuffer);
  }
}

export function main(): void {
  while (true) {
    const message: ArrayBuffer = getMessage();
    sendMessage(message);
  }
}

main();
