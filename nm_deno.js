#!/usr/bin/env -S /home/user/bin/deno -A 
// Deno Native Messaging host
// guest271314, 10-5-2022

const buffer = new ArrayBuffer(0, { maxByteLength: 1024 ** 2 * 64 });
const view = new DataView(buffer);
const encoder = new TextEncoder();
const decoder = new TextDecoder();
const maxMessageLengthFromHost = 209715;
const { readable } = Deno.stdin;
const { writable } = Deno.stdout;
const { exit } = Deno;
const writer = writable.getWriter();
function encodeMessage(message) {
  return encoder.encode(JSON.stringify(message));
}
async function* getMessage() {
  let messageLength = 0;
  let readOffset = 0;
  for await (let message of readable) {
    if (buffer.byteLength === 0 && messageLength === 0) {
      buffer.resize(4);
      for (let i = 0; i < 4; i++) {
        view.setUint8(i, message[i]);
      }
      messageLength = view.getUint32(0, true);
      message = message.subarray(4);
      buffer.resize(0);
    }
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
async function sendMessage(message) {
  const json = JSON.parse(decoder.decode(message));
  if (Array.isArray(json) && json.length > maxMessageLengthFromHost) {
    for (let i = 0; i < json.length; i += maxMessageLengthFromHost) {
      const messageChunk = encodeMessage(
        json.slice(i, i + maxMessageLengthFromHost)
      );
      const u8 = new Uint8Array(4 + messageChunk.length);
      u8.set(new Uint8Array(new Uint32Array([messageChunk.length]).buffer), 0);
      u8.set(messageChunk, 4);
      await writer.write(u8);
      await writer.ready;
    }
  } else {
    const encoded = encodeMessage(json);
    const u8 = new Uint8Array(4 + encoded.length);
    u8.set(new Uint8Array(new Uint32Array([encoded.length]).buffer), 0);
    u8.set(encoded, 4);
    return await writer.write(u8);
    await writer.ready;
  }
}
try {
  for await (const message of getMessage()) {
    await sendMessage(message);
  }
} catch (e) {
  sendMessage(encodeMessage(e.message));
  exit();
}
export {
  encodeMessage,
  exit,
  getMessage,
  readable,
  sendMessage,
  writable
};
