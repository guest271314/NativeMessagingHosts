// Dart Native Messaging host
// guest271314 10-4-2026
//
// dart compile exe nm_dart.dart -S debug_dart.txt -o nm_dart
// WASM doesn't work right now... No WASI
// dart compile wasm nm_dart.dart -S debug_dart_wasm.txt -o nm_dart.wasm

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

void main() async {
  // Pre-allocate a highly efficient non-copying matrix collector
  final BytesBuilder accumulator = BytesBuilder(copy: false);
  final outputController = StreamController<List<int>>();
  final stdoutDone = stdout.addStream(outputController.stream);

  try {
    await for (final chunk in stdin) {
      accumulator.add(chunk);
      
      // OPTIMIZATION: Only evaluate the buffer when we have at least the 4-byte header.
      // This completely skips processing data on partial chunk ticks.
      if (accumulator.length < 4) continue;

      // Extract the length field safely without allocating or flattening the array
      final Uint8List tempHeader = accumulator.toBytes();
      final int messageLength = ByteData.sublistView(tempHeader).getUint32(0, Endian.little);

      // CRITICAL PERFORMANCE FIX: Do not flatten the 64 MiB stream array until 
      // the absolute entire payload frame has arrived from the OS pipe.
      if (accumulator.length < 4 + messageLength) {
        continue; 
      }

      // Flatten exactly once per full message block
      final Uint8List fullPayload = accumulator.takeBytes();
      final Uint8List message = Uint8List.sublistView(fullPayload, 4, 4 + messageLength);

      // If any trailing bytes from a secondary message arrived, preserve them cleanly
      if (fullPayload.length > 4 + messageLength) {
        accumulator.add(Uint8List.sublistView(fullPayload, 4 + messageLength));
      }

      // Send the fully populated payload to the chunking processor
      await sendMessageAsync(message, outputController);
    }
  } catch (e) {
    // Suppress safely to align with original script fallback design
  } finally {
    await outputController.close();
    await stdoutDone;
    exit(0);
  }
}

Future<void> sendMessageAsync(Uint8List message, StreamController<List<int>> output) async {
  const int COMMA = 44;
  const int OPEN_BRACKET = 91;
  const int CLOSE_BRACKET = 93;
  const int CHUNK_SIZE = 1024 * 1024; // 1 MiB

  if (message.length <= CHUNK_SIZE) {
    final payload = Uint8List(4 + message.length);
    ByteData.sublistView(payload).setUint32(0, message.length, Endian.little);
    payload.setRange(4, 4 + message.length, message);
    output.add(payload);
    return;
  }

  int index = 0;

  while (index < message.length) {
    int searchStart = index + CHUNK_SIZE - 8;
    int splitIndex = message.length;

    if (searchStart < message.length) {
      for (int i = searchStart; i < message.length; i++) {
        if (message[i] == COMMA) {
          splitIndex = i;
          break;
        }
      }
    }

    final rawChunk = Uint8List.sublistView(message, index, splitIndex);
    if (rawChunk.isEmpty) break;

    final startByte = rawChunk.first;
    final endByte = rawChunk[rawChunk.length - 1];

    bool hasPrepend = (startByte == COMMA);
    bool hasAppend = (endByte != CLOSE_BRACKET);
    if (startByte == OPEN_BRACKET && endByte != CLOSE_BRACKET) {
      hasPrepend = false;
      hasAppend = true;
    }

    int bodyLength = rawChunk.length;
    int sourceOffset = 0;
    if (startByte == COMMA) {
      sourceOffset = 1;
      bodyLength -= 1;
    }

    int chunkPayloadLength = bodyLength + (hasPrepend ? 1 : 0) + (hasAppend ? 1 : 0);
    final outputBuffer = Uint8List(4 + chunkPayloadLength);
    
    ByteData.sublistView(outputBuffer).setUint32(0, chunkPayloadLength, Endian.little);

    int cursor = 4;
    if (hasPrepend || startByte == COMMA) {
      outputBuffer[cursor] = OPEN_BRACKET;
      cursor++;
    }

    outputBuffer.setRange(cursor, cursor + bodyLength, rawChunk, sourceOffset);
    cursor += bodyLength;

    if (hasAppend) {
      outputBuffer[cursor] = CLOSE_BRACKET;
    }

    output.add(outputBuffer);
    
    index = splitIndex;
  }
}
