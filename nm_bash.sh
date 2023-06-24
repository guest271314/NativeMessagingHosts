#!/bin/bash
# Bash Native Messaging host
# guest271314 6-24-2023
set -x
#!/bin/bash
getMessage() {
  length=$(head -q -z --bytes=4 -| od -An -td4 -)
  message=$(head -q -z --bytes=$((length)) -)
  sendMessage "$message"
}
# https://stackoverflow.com/a/24777120
sendMessage() {
  message="$*"
  # Calculate the byte size of the string.
  # NOTE: This assumes that byte length is identical to the string length!
  # Do not use multibyte (unicode) characters, escape them instead, e.g.
  # message='"Some unicode character:\u1234"'
  messagelen=${#message}
  # Convert to an integer in native byte order.
  # If you see an error message in Chrome's stdout with
  # "Native Messaging host tried sending a message that is ... bytes long.",
  # then just swap the order, i.e. messagelen1 <-> messagelen4 and
  # messagelen2 <-> messagelen3
  messagelen1=$(((messagelen) & 0xFF))
  messagelen2=$(((messagelen >> 8) & 0xFF))
  messagelen3=$(((messagelen >> 16) & 0xFF))
  messagelen4=$(((messagelen >> 24) & 0xFF))
  # Print the message byte length followed by the actual message.
  printf "$(printf '\\x%x\\x%x\\x%x\\x%x' \
    $messagelen1 $messagelen2 $messagelen3 $messagelen4)%s" "$message"
}

main() {
  while true; do
    getMessage
  done
}

main
