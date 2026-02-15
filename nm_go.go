// Go Native Messaging host
// guest271314, 2-14-2026
// Source: Node.js Native Messaging host https://github.com/guest271314/native-messaging-nodejs/nm_nodejs.js

package main

import (
  "bufio"
  "encoding/binary"
  "io"
  "os"
)

const CHUNK_SIZE = 1024 * 1024

var reader = bufio.NewReader(os.Stdin)

func main() {
  for {
    message, err := getMessage()
    if err != nil {
      if err == io.EOF {
        break
      }
      os.Exit(1)
    }

    sendMessage(os.Stdout, message)
  }
}

func getMessage() ([]byte, error) {
  var length uint32
  err := binary.Read(reader, binary.LittleEndian, &length)
  if err != nil {
    return nil, err
  }

  message := make([]byte, length)
  _, err = io.ReadFull(reader, message)
  if err != nil {
    return nil, err
  }

  return message, nil
}

func sendMessage(writer io.Writer, message []byte) {
  if len(message) <= CHUNK_SIZE {
    binary.Write(writer, binary.LittleEndian, uint32(len(message)))
    writer.Write(message)
    return
  }

  index := 0
  for index < len(message) {
    splitIndex := index + CHUNK_SIZE - 8
    if splitIndex >= len(message) {
      splitIndex = len(message)
    } else {
      commaPos := -1
      for i := splitIndex; i < len(message); i++ {
        if message[i] == ',' {
          commaPos = i
          break
        }
      }
      if commaPos == -1 {
        splitIndex = len(message)
      } else {
        splitIndex = commaPos
      }
    }

    rawChunk := message[index:splitIndex]
    startsWithComma := len(rawChunk) > 0 && rawChunk[0] == ','
    endsWithBracket := len(rawChunk) > 0 && rawChunk[len(rawChunk)-1] == ']'

    var finalChunk []byte
    if startsWithComma {
      finalChunk = append([]byte{'['}, rawChunk[1:]...)
    } else {
      finalChunk = append([]byte(nil), rawChunk...)
    }

    if !endsWithBracket {
      finalChunk = append(finalChunk, ']')
    }

    binary.Write(writer, binary.LittleEndian, uint32(len(finalChunk)))
    writer.Write(finalChunk)
    index = splitIndex
  }
}