#!/bin/bash
# https://stackoverflow.com/a/76549088
LC_ALL=C IFS=
readmsg() {
  # return non-zero if fewer than 4 bytes of input available
  # or if message is shorter than length specified by first
  # 4 bytes of input
  # otherwise, set the variable $msg and return 0

  local -i i n len=0
  for ((i = 0; i < 4; i++)); do
    read -r -d '' -n 1 || return
    printf -v n %d "'$REPLY"
    # https://www.reddit.com/r/learnprogramming/comments/1atbq77/comment/kqw7ssw/
    len+=$((n << i * 8))
  done
  read -r -N "$len" && ((${#REPLY} == len)) && msg=$REPLY
  sendmsg "$msg"
}

sendmsg() {
  local x
  printf -v x %08X "${#1}"
  printf %b%s "\x${x:6:2}\x${x:4:2}\x${x:2:2}\x${x:0:2}" "$1"
}

while true; do
  # do_something "$msg"
  readmsg
done
