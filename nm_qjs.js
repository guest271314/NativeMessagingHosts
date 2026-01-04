#!/usr/bin/env -S /home/user/bin/qjs -m --std
// QuickJS Native Messaging host
// guest271314, 5-6-2022

function getMessage() {
  const header = new Uint32Array(1);
  std.in.read(header.buffer, 0, 4);
  const output = new Uint8Array(header[0]);
  const len = std.in.read(output.buffer, 0, output.length);
  return output;
}

function encodeMessage(message) {
  return new Uint8Array(
    [...JSON.stringify(message)].map((s) => s.codePointAt(0)),
  );
}

function sendMessage(message) {
  if (message.length > 1024 ** 2) {
    const json = message;
    const data = new Array();
    let fromIndex = 1024 ** 2 - 8;
    let index = 0;
    let i = 0;
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
    for (let j = 0; j < data.length; j++) {
      const start = data[j][0];
      const end = data[j][data[j].length - 1];
      if (start === 91 && end !== 44 && end !== 93) {
        const x = new Uint8Array(data[j].length + 1);
        for (let i2 = 0; i2 < data[j].length; i2++) {
          x[i2] = data[j][i2];
        }
        x[x.length - 1] = 93;
        data[j] = x;
      }
      if (start === 44 && end !== 93) {
        const x = new Uint8Array(data[j].length + 1);
        x[0] = 91;
        for (let i2 = 1; i2 < data[j].length; i2++) {
          x[i2] = data[j][i2];
        }
        x[x.length - 1] = 93;
        data[j] = x;
      }
      if (start === 44 && end === 93) {
        const x = new Uint8Array(data[j].length);
        x[0] = 91;
        for (let i2 = 1; i2 < data[j].length; i2++) {
          x[i2] = data[j][i2];
        }
        data[j] = x;
      }
    }
    for (let k = 0; k < data.length; k++) {
      const arr = data[k];
      const header = Uint32Array.from(
        {
          length: 4,
        },
        (_, index) => (arr.length >> (index * 8)) & 0xff,
      );
      const output = new Uint8Array(header.length + arr.length);
      output.set(header, 0);
      output.set(arr, 4);
      std.out.write(output.buffer, 0, output.length);
      std.out.flush();
      std.gc();
    }
  } else {
    const header = Uint32Array.from({
      length: 4,
    }, (_, index) => (message.length >> (index * 8)) & 0xff);
    const output = new Uint8Array(header.length + message.length);
    output.set(header, 0);
    output.set(message, 4);
    std.out.write(output.buffer, 0, output.length);
    std.out.flush();
    std.gc();
  }
}

function main() {
  while (true) {
    const message = getMessage();
    sendMessage(message);
  }
}

try {
  main();
} catch (e) {
  // std.writeFile("err.txt", e.message);
  std.exit(0);
}
