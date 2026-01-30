#!/usr/bin/env bash
# Bash Native Messaging host
# guest271314 6-24-2023
#
# https://gemini.google.com/share/continue/4372b594e5a1
# https://claude.ai/chat/19e5e49a-cb73-40b2-b784-3cab53fa4247
#
export LC_ALL=C

CHUNKSZ=$((1024 * 1024)) # 1 MiB

# Optimized Header Creation: Pre-generate hex to avoid subshells
sendMessage() {
  local data="$1"
  local len=${#data}

  # Write 4-byte Little Endian header
  # Using a single printf with bit-shifted values is faster
  printf "\\x$(printf %02x $((len & 0xFF)))\\x$(printf %02x $((len >> 8 & 0xFF)))\\x$(printf %02x $((len >> 16 & 0xFF)))\\x$(printf %02x $((len >> 24 & 0xFF)))%s" "$data"
}

getMessage() {
  # Read 4-byte header to get length
  local header_bytes
  header_bytes=$(dd bs=4 count=1 2>/dev/null | od -An -t u4 | tr -dc '0-9')
  
  [[ -z "$header_bytes" ]] && exit 0
  local total_len=$header_bytes
  
  # Read full payload
  local message
  message=$(dd bs="$total_len" count=1 iflag=fullblock 2>/dev/null)
  
  # --- NEW LOGIC: Send in one go if size is within limits ---
  if (( total_len <= CHUNKSZ )); then
    sendMessage "$message"
    return
  fi

  # --- Chunking Logic for messages > 1 MiB ---
  local index=0
  while (( index < total_len )); do
    local split_index=$total_len
    local search_start=$((index + CHUNKSZ - 8))
    
    if (( search_start < total_len )); then
      local window="${message:search_start:2048}"
      if [[ "$window" == *","* ]]; then
        local before_comma="${window%%,*}"
        split_index=$((search_start + ${#before_comma}))
      fi
    fi
    
    local raw_chunk="${message:index:split_index-index}"
    local first_char="${raw_chunk:0:1}"
    local last_char="${raw_chunk: -1}"
    
    # Structure correction to ensure chunks remain valid JSON arrays
    if [[ "$first_char" == "[" ]]; then
      if [[ "$last_char" == "]" ]]; then
        sendMessage "$raw_chunk"
      else
        sendMessage "${raw_chunk}]"
      fi
    elif [[ "$first_char" == "," ]]; then
      if [[ "$last_char" == "]" ]]; then
        sendMessage "[${raw_chunk:1}"
      else
        sendMessage "[${raw_chunk:1}]"
      fi
    else
      if [[ "$last_char" == "]" ]]; then
        sendMessage "[${raw_chunk}"
      else
        sendMessage "[${raw_chunk}]"
      fi
    fi
    
    index=$split_index
  done
}

while true; do
  getMessage
done
