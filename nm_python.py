#!/usr/bin/env -S python3 -u
# https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_messaging
# https://github.com/mdn/webextensions-examples/pull/157
# Note that running python with the `-u` flag is required on Windows,
# in order to ensure that stdin and stdout are opened in binary, rather
# than text, mode.
# Python Native Messaging host
# guest271314, 1-9-2026
# https://discuss.python.org/t/how-to-support-optimized-64-mib-json-parsing-and-streaming-for-native-messaging-host/105567/9
# https://github.com/guest271314/NativeMessagingHosts/blob/main/nm_nodejs.js
# https://www.codeconvert.ai/javascript-to-python-converter?id=53a74277-8ee6-4f73-9c22-cb65296481ca
import sys
import asyncio
import gc
from struct import pack, unpack

ab = bytearray()
totalMessageLength = 0
currentMessageLength = 0

def sendMessage(message: bytearray):
    COMMA = 44
    OPEN_BRACKET = 91
    CLOSE_BRACKET = 93
    CHUNK_SIZE = 1024 * 1024

    if len(message) <= CHUNK_SIZE:
        sys.stdout.buffer.write(pack('<I', len(message)))
        sys.stdout.buffer.write(message)
        sys.stdout.buffer.flush()
        return

    index = 0
    while index < len(message):
        if index + CHUNK_SIZE - 8 >= len(message):
            splitIndex = len(message)
        else:
            try:
                splitIndex = message.index(COMMA, index + CHUNK_SIZE - 8)
            except ValueError:
                splitIndex = len(message)

        rawChunk = message[index:splitIndex]
        startByte = rawChunk[0]
        endByte = rawChunk[-1]
        prepend = None
        append = None

        if startByte == OPEN_BRACKET and endByte != CLOSE_BRACKET:
            append = CLOSE_BRACKET
        elif startByte == COMMA:
            prepend = OPEN_BRACKET
            if endByte != CLOSE_BRACKET:
                append = CLOSE_BRACKET

        bodyLength = len(rawChunk)
        hasPrepend = prepend is not None
        hasAppend = append is not None
        sourceOffset = 0

        if startByte == COMMA:
            sourceOffset = 1
            bodyLength -= 1

        totalLength = 4 + (1 if hasPrepend else 0) + bodyLength + (1 if hasAppend else 0)
        output = bytearray(totalLength)
        datacurrentMessageLength = totalLength - 4

        output[0:4] = pack('<I', datacurrentMessageLength)
        cursor = 4

        if hasPrepend:
            output[cursor] = prepend
            cursor += 1
        elif startByte == COMMA:
            output[cursor] = OPEN_BRACKET
            cursor += 1

        output[cursor:cursor+bodyLength] = rawChunk[sourceOffset:sourceOffset+bodyLength]
        cursor += bodyLength

        if hasAppend:
            output[cursor] = append

        sys.stdout.buffer.write(output)
        sys.stdout.buffer.flush()
        index = splitIndex

async def getMessage():
    global ab, totalMessageLength, currentMessageLength
    loop = asyncio.get_event_loop()
    reader = asyncio.StreamReader()
    protocol = asyncio.StreamReaderProtocol(reader)
    await loop.connect_read_pipe(lambda: protocol, sys.stdin)

    while True:
        data = await reader.read(65536)
        if not data:
            break

        if len(ab) == 0 and totalMessageLength == 0 and currentMessageLength == 0:
            totalMessageLength = unpack('<I', data[:4])[0]
            ab = bytearray(totalMessageLength)
            message = data[4:]
            ab[0:len(message)] = message
            currentMessageLength = len(message)
        else:
            if currentMessageLength < totalMessageLength:
                message = data
                ab[currentMessageLength:currentMessageLength+len(message)] = message
                currentMessageLength += len(message)

        if currentMessageLength == totalMessageLength:
            sendMessage(ab)
            currentMessageLength = 0
            totalMessageLength = 0
            ab = bytearray()
            gc.collect()

try:
    asyncio.run(getMessage())
except Exception:
    sys.exit(1)
