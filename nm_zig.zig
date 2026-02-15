// Zig Native Messaging host
// guest271314, 2-14-2026
// Source: Node.js Native Messaging host https://github.com/guest271314/native-messaging-nodejs/nm_nodejs.js

const std = @import("std");

const CHUNK_SIZE = 1024 * 1024;

pub fn main() !void {
  var gpa = std.heap.GeneralPurposeAllocator(.{}){};
  defer _ = gpa.deinit();
  const allocator = gpa.allocator();

  while (true) {
  const message = getMessage(allocator) catch |err| {
    if (err == error.EndOfStream) break;
    return err;
  };
  defer allocator.free(message);

  try sendMessage(message, allocator);
  }
}

fn getMessage(allocator: std.mem.Allocator) ![]u8 {
  const fd: i32 = 0; // STDIN
  var h_buf: [4]u8 = undefined;
  
  // Raw system read for the 4-byte header
  const h_len = std.os.linux.read(fd, &h_buf, 4);
  if (h_len < 4) return error.EndOfStream;

  const msg_len = std.mem.readInt(u32, &h_buf, .little);
  const buf = try allocator.alloc(u8, msg_len);
  errdefer allocator.free(buf);

  var total_read: usize = 0;
  while (total_read < msg_len) {
  const amt = std.os.linux.read(fd, buf[total_read..].ptr, msg_len - total_read);
  if (amt <= 0) break;
  total_read += @intCast(amt);
  }
  return buf;
}

fn sendMessage(message: []const u8, allocator: std.mem.Allocator) !void {
  const fd: i32 = 1; // STDOUT

  if (message.len <= CHUNK_SIZE) {
    var h_buf: [4]u8 = undefined;
    std.mem.writeInt(u32, &h_buf, @intCast(message.len), .little);
    _ = std.os.linux.write(fd, &h_buf, 4);
    _ = std.os.linux.write(fd, message.ptr, message.len);
    return;
  }

  var index: usize = 0;
  while (index < message.len) {
    var split_index = index + CHUNK_SIZE - 8;
    if (split_index >= message.len) {
      split_index = message.len;
    } else {
      if (std.mem.indexOfScalarPos(u8, message, split_index, ',')) |pos| {
        split_index = pos;
      } else {
        split_index = message.len;
      }
    }

    const raw_chunk = message[index..split_index];
    const starts_with_comma = raw_chunk.len > 0 and raw_chunk[0] == ',';
    const ends_with_bracket = raw_chunk.len > 0 and raw_chunk[raw_chunk.len - 1] == ']';

    // Manual buffer assembly to avoid ArrayList API issues
    const chunk_buf = try allocator.alloc(u8, raw_chunk.len + 2);
    defer allocator.free(chunk_buf);
  
    var cursor: usize = 0;
    if (starts_with_comma) {
      chunk_buf[0] = '[';
      @memcpy(chunk_buf[1..raw_chunk.len], raw_chunk[1..]);
      cursor = raw_chunk.len;
    } else {
      @memcpy(chunk_buf[0..raw_chunk.len], raw_chunk);
      cursor = raw_chunk.len;
    }

    if (!ends_with_bracket) {
      chunk_buf[cursor] = ']';
      cursor += 1;
    }

    var h_buf: [4]u8 = undefined;
    std.mem.writeInt(u32, &h_buf, @intCast(cursor), .little);
    _ = std.os.linux.write(fd, &h_buf, 4);
    _ = std.os.linux.write(fd, chunk_buf[0..cursor].ptr, cursor);

    index = split_index;
  }
}