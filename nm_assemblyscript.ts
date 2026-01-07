// AssemblyScript Native Messaging host
// guest271314, 10-5-2025

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

// https://gist.github.com/guest271314/c88d281572aadb2cc6265e3e9eb09810
// Define constants for JSON characters
const COMMA: u8 = 44;
const OPEN_BRACKET: u8 = 91;
const CLOSE_BRACKET: u8 = 93;
const CHUNK_SIZE: i32 = 1024 * 1024; // 1MB

/**
 * Optimized AssemblyScript sendMessage
 * Uses a single-pass streaming approach to minimize memory allocations.
 */
function sendMessage(messageBuffer: ArrayBuffer): void {
  const message = Uint8Array.wrap(messageBuffer);
  const totalLen = message.length;

  // Handle small messages directly
  if (totalLen <= CHUNK_SIZE) {
    const messageBufferHeader = new ArrayBuffer(4);
    new DataView(messageB).setUint32(
      0,
      data.buffer.byteLength,
      true,
    );
    process.stdout.write(messageBufferHeader);
    process.stdout.write(message.buffer);
    return;
  }

  let index: i32 = 0;

  while (index < totalLen) {
    // 1. Determine split point
    let searchStart = index + CHUNK_SIZE - 8;
    let splitIndex: i32;

    if (searchStart >= totalLen) {
      splitIndex = totalLen;
    } else {
      // Find the next comma
      splitIndex = -1;
      for (let i = searchStart; i < totalLen; i++) {
        if (unchecked(message[i]) == COMMA) {
          splitIndex = i;
          break;
        }
      }
      if (splitIndex == -1) splitIndex = totalLen;
    }

    // 2. Identify characteristics of the current slice
    let startByte = unchecked(message[index]);
    let endByte = unchecked(message[splitIndex - 1]);
    
    // We determine if we need to add brackets to make this chunk a valid JSON array fragment
    let needsOpen = false;
    let needsClose = false;
    let skipFirstByte = false;

    if (startByte == OPEN_BRACKET) {
      if (endByte != CLOSE_BRACKET) needsClose = true;
    } else if (startByte == COMMA) {
      needsOpen = true;
      skipFirstByte = true; // Replace comma with '['
      if (endByte != CLOSE_BRACKET) needsClose = true;
    }

    // 3. Calculate payload size
    let bodyStart = skipFirstByte ? index + 1 : index;
    let bodyLen = splitIndex - bodyStart;
    let payloadLen = bodyLen + (needsOpen ? 1 : 0) + (needsClose ? 1 : 0);

    // 4. Allocate and build the output buffer (4 byte header + payload)
    let output = new Uint8Array(4 + payloadLen);
    
    // Write 32-bit Length Header (Little Endian)
    unchecked(output[0] = <u8>(payloadLen & 0xFF));
    unchecked(output[1] = <u8>((payloadLen >> 8) & 0xFF));
    unchecked(output[2] = <u8>((payloadLen >> 16) & 0xFF));
    unchecked(output[3] = <u8>((payloadLen >> 24) & 0xFF));

    let cursor = 4;
    if (needsOpen) {
      unchecked(output[cursor++] = OPEN_BRACKET);
    }

    // Fast memory copy using .set()
    output.set(message.subarray(bodyStart, splitIndex), cursor);
    cursor += bodyLen;

    if (needsClose) {
      unchecked(output[cursor] = CLOSE_BRACKET);
    }

    // 5. Native Write
    // Assuming 'std' is provided by your environment (like QuickJS or a WASI wrapper)
    //std.out.write(output.buffer, 0, output.length);
    //std.out.flush();
    process.stdout.write(output.buffer);

    // Advance
    index = splitIndex;
  }
}

export function main(): void {
  while (true) {
    const message: ArrayBuffer = getMessage();
    sendMessage(message);
  }
}

main();
