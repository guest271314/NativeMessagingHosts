#!/usr/bin/env -S /home/user/bin/lua
-- Lua Native Messaging host
-- guest271314, 2-18-2024
-- // Source: Node.js Native Messaging host https://github.com/guest271314/native-messaging-nodejs/nm_nodejs.js

local io = require("io")
local string = require("string")
local math = require("math")

-- Helper for 32-bit Little Endian header
local function encode_header(len)
  local b1 = len % 256
  local b2 = math.floor(len / 256) % 256
  local b3 = math.floor(len / 65536) % 256
  local b4 = math.floor(len / 16777216) % 256
  return string.char(b1, b2, b3, b4)
end

local function decode_header(header)
  local b1, b2, b3, b4 = string.byte(header, 1, 4)
  return b1 + (b2 * 256) + (b3 * 65536) + (b4 * 16777216)
end

function getMessage()
  local header = io.stdin:read(4)
  if not header then return nil end
  
  local length = decode_header(header)
  local message = io.stdin:read(length)
  if not message then return nil end
  
  return message
end

function sendMessage(message)
  local limit = 1024 ^ 2 -- 1 MiB
  
  -- If message is small, send as is (assuming it's valid JSON)
  if #message <= limit then
    local header = encode_header(#message)
    io.stdout:write(header)
    io.stdout:write(message)
    io.stdout:flush()
    return
  end

  -- Large message logic: Split at commas to maintain JSON structure
  local index = 1
  while index <= #message do
    local next_limit = index + limit - 8
    local split_at = string.find(message, ",", next_limit, true)
    
    local chunk
    if not split_at then
      chunk = string.sub(message, index)
      index = #message + 1
    else
      chunk = string.sub(message, index, split_at)
      index = split_at + 1
    end

    -- Ensure the chunk is a valid JSON array fragment
    local first = string.byte(chunk, 1)
    local last = string.byte(chunk, #chunk)

    -- Logic: Ensure every chunk starts with [ and ends with ]
    -- if it's a middle segment
    if first ~= 91 then -- Doesn't start with [
      chunk = "[" .. chunk
    end
    if string.byte(chunk, #chunk) ~= 93 then -- Doesn't end with ]
      -- If it ends with a comma, remove it or wrap it
      if string.byte(chunk, #chunk) == 44 then
        chunk = string.sub(chunk, 1, -2) .. "]"
      else
        chunk = chunk .. "]"
      end
    end

    local header = encode_header(#chunk)
    io.stdout:write(header)
    io.stdout:write(chunk)
    io.stdout:flush()
    collectgarbage("step")
  end
  
  collectgarbage("collect")
end

-- Main Read Loop
while true do
  local message = getMessage()
  if not message then break end
  
  sendMessage(message)
end
