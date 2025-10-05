function getMessage(): ArrayBuffer {
  const header = new ArrayBuffer(4);
  process.stdin.read(header);
  const headerView = new DataView(header);
  const messageLength: i32 = headerView.getUint32(0, true);
  const messageBuffer = new ArrayBuffer(messageLength);
  const messageView = new DataView(messageBuffer);
  let index: i32 = 0;
  while (true) {
    const currentBuffer = new ArrayBuffer(65536);
    const currentBufferLength: i32 = process.stdin.read(currentBuffer);
    const currentBufferView = new DataView(currentBuffer);
    for (let i: i32 = 0; i < currentBufferLength; i++, index++) {
      messageView.setUint8(index, currentBufferView.getUint8(i));
    }
    if (index === messageLength) {
      break;
    }
  }
  return messageBuffer;
}

function sendMessage(messageBuffer: ArrayBuffer): void {
  const messageBufferHeader = new ArrayBuffer(4);
  new DataView(messageBufferHeader).setUint32(
    0,
    messageBuffer.byteLength,
    true,
  );
  process.stdout.write(messageBufferHeader);
  process.stdout.write(messageBuffer);
}

export function main(): void {
  while (true) {
    const message: ArrayBuffer = getMessage();
    sendMessage(message);
  }
}

main();
