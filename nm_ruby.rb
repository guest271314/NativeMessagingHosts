#!/usr/bin/env -S /home/user/bin/ruby
# Ruby Native Messaging host
# guest271314, 3-25-2026

STDIN.binmode
STDOUT.binmode

# 1 MiB limit for Native Messaging host to client
MAX_SIZE = 1024 * 1024 

def get_message
  header = STDIN.read(4)
  return nil unless header && header.bytesize == 4
  length = header.unpack1('V')
  STDIN.read(length)
end

def send_message(message)
  total_len = message.bytesize
  
  if total_len <= MAX_SIZE
    STDOUT.write([total_len].pack('V'))
    STDOUT.write(message)
    STDOUT.flush
    return
  end

  offset = 0
  while offset < total_len
    # Look for a comma near the 1MB mark
    # We subtract 10 bytes to leave a safe buffer for added brackets
    search_limit = [offset + MAX_SIZE - 2, total_len - 1].min
    
    # Find the last comma before the 1MB limit
    chunk_end = message.rindex(',', search_limit)

    # If no comma or we're at the end, take the rest of the string
    if chunk_end.nil? || chunk_end < offset || (offset + MAX_SIZE >= total_len)
      chunk_end = total_len
    end

    raw_slice = message.byteslice(offset, chunk_end - offset).strip
    
    # Remove leading/trailing commas so we don't end up with [,,1,2]
    clean_slice = raw_slice.delete_prefix(',').delete_suffix(',')

    # Ensure the slice is a valid JSON array
    # 1. Add opening bracket if missing
    payload = clean_slice.start_with?('[') ? clean_slice : "[#{clean_slice}"
    # 2. Add closing bracket if missing
    payload = payload.end_with?(']') ? payload : "#{payload}]"

    # Send length-prefixed frame
    STDOUT.write([payload.bytesize].pack('V'))
    STDOUT.write(payload)
    STDOUT.flush

    # Move offset past the comma we found
    offset = (chunk_end == total_len) ? total_len : chunk_end + 1
  end
end

begin
  while (msg = get_message)
    send_message(msg)
  end
rescue StandardError
  exit(0)
end
