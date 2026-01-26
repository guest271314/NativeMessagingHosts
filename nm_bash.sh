#!/usr/bin/env bash
# Bash Native Messaging host
# guest271314 6-24-2023
#
# https://gemini.google.com/share/continue/4372b594e5a1
# https://claude.ai/chat/19e5e49a-cb73-40b2-b784-3cab53fa4247
#
# High-Speed Optimized Bash Native Messaging Host
export LC_ALL=C

CHUNKSZ=$((1024 * 1024))

# Optimization 1: Pre-calculate the length header bytes using bit-shifting
# to avoid calling $(printf) inside the loop.
sendMessage() {
  local data="$1"
  local len=${#data}

  # Write 4-byte LE header directly. 
  # This syntax is faster than $(printf hex) for every call.
  printf "\\x$(printf %02x $((len & 0xFF)))\\x$(printf %02x $((len >> 8 & 0xFF)))\\x$(printf %02x $((len >> 16 & 0xFF)))\\x$(printf %02x $((len >> 24 & 0xFF)))%s" "$data"
}

getMessage() {
  # Optimization 2: Use dd with a specific pipe to read the 4-byte header
  local header_bytes
  header_bytes=$(dd bs=4 count=1 2>/dev/null | od -An -t u4 | tr -dc '0-9')
  
  [[ -z "$header_bytes" ]] && exit 0
  local total_len=$header_bytes
  
  # Read full payload into memory
  local message
  message=$(dd bs="$total_len" count=1 iflag=fullblock 2>/dev/null)
  
  local index=0
  # Optimization 3: Arithmetic loops are much faster in (( ))
  while (( index < total_len )); do
    local split_index=$total_len
    local search_start=$((index + CHUNKSZ - 8))
    
    if (( search_start < total_len )); then
      # Optimization 4: Limit search window to 2KB to avoid scanning 
      # the entire remaining multi-MB string for a comma.
      local window="${message:search_start:2048}"
      if [[ "$window" == *","* ]]; then
        local before_comma="${window%%,*}"
        split_index=$((search_start + ${#before_comma}))
      fi
    fi
    
    # Optimization 5: Single-pass slicing
    local raw_chunk="${message:index:split_index-index}"
    local first_char="${raw_chunk:0:1}"
    local last_char="${raw_chunk: -1}"
    
    # Optimization 6: Minimize string concatenation (final_chunk construction)
    # Bash creates a new string in memory for every 's1 + s2' operation.
    if [[ "$first_char" == "[" ]]; then
      if [[ "$last_char" == "]" ]]; then
        sendMessage "$raw_chunk"
      else
        sendMessage "${raw_chunk}]"
      fi
    elif [[ "$first_char" == "," ]]; then
      # We strip the comma and add the bracket
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

# Main Native Messaging loop
while true; do
  getMessage
done
