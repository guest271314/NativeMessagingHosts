#!/usr/bin/env -S python3 -u
# https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/Native_messaging
# https://github.com/mdn/webextensions-examples/pull/157
# Note that running python with the `-u` flag is required on Windows,
# in order to ensure that stdin and stdout are opened in binary, rather
# than text, mode.

import sys
import json
import struct
import traceback

try:
    # Python 3.x version
    # Read a message from stdin and decode it.
    def getMessage():
        rawLength = sys.stdin.buffer.read(4)
        # if len(rawLength) == 0:
        #    sys.exit(0)
        messageLength = struct.unpack('@I', rawLength)[0]
        message = sys.stdin.buffer.read(messageLength).decode('utf-8')
        return json.loads(message)

    # Encode a message for transmission,
    # given its content.
    def encodeMessage(messageContent):
        # https://stackoverflow.com/a/56563264
        # https://docs.python.org/3/library/json.html#basic-usage
        # To get the most compact JSON representation, you should specify 
        # (',', ':') to eliminate whitespace.
        encodedContent = json.dumps(messageContent, separators=(',', ':')).encode('utf-8')
        encodedLength = struct.pack('@I', len(encodedContent))
        return {'length': encodedLength, 'content': encodedContent}

    # Send an encoded message to stdout
    def sendMessage(encodedMessage):
        sys.stdout.buffer.write(encodedMessage['length'])
        sys.stdout.buffer.write(encodedMessage['content'])
        sys.stdout.buffer.flush()
        
    while True:
        receivedMessage = getMessage()
        sendMessage(encodeMessage(receivedMessage))

except Exception as e:
    sys.stdout.buffer.flush()
    sys.stdin.buffer.flush()
    # https://discuss.python.org/t/how-to-read-1mb-of-input-from-stdin/22534/14
    with open('nm_python.log', 'w', encoding='utf-8') as f:
        traceback.print_exc(file=f)
    sys.exit(0)