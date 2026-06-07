//usr/bin/env -S /home/user/bin/zig run "$0"
// Zig Native Messaging host
// guest271314, 3-20-2026
// Source: QuickJS Native Messaging host https://github.com/guest271314/native-messaging-quickjs/nm_qjs.js
// Zig 0.16.0
// zig build-exe nm_zig_stable.zig -O ReleaseSmall
// zig build-exe nm_zig_stable.zig -target wasm32-wasi -O ReleaseSmall

const std = @import("std");

const CHUNK_SIZE = 1024 * 1024;

/// Zig 0.16.0 main entry point structure
pub fn main(init: std.process.Init) !void {
  const allocator = init.gpa;
  const io = init.io;

  while (true) {
    const message = getMessage(allocator, io) catch |err| {
      if (err == error.EndOfStream) break;
      return err;
    };

    try sendMessage(message, allocator, io);
  }
}

/// Read STDIN from browser
pub fn getMessage(allocator: std.mem.Allocator, io: std.Io) ![]u8 {
  const stdin = std.Io.File.stdin();

  // Explicit 4-byte explicit array block type declaration
  var h_buf: [4]u8 = undefined;

  // Instantiate reader interface passing an ephemeral stack buffer array workspace
  var file_buffer: [4096]u8 = undefined;
  var file_reader = stdin.reader(io, &file_buffer);

  const header_slice = try file_reader.interface.takeArray(4);
  @memcpy(&h_buf, header_slice);

  const msg_len = std.mem.readInt(u32, &h_buf, .little);

  // Initialize standard memory accumulating stream writer
  var target_list = std.Io.Writer.Allocating.init(allocator);
  defer target_list.deinit();
  const writer_interface = &target_list.writer;

  var total_read: usize = 0;
  while (total_read < msg_len) {
    const needed = msg_len - total_read;
    const to_read = @min(needed, file_buffer.len);

    const chunk = try file_reader.interface.take(to_read);
    if (chunk.len == 0) return error.EndOfStream;

    try writer_interface.writeAll(chunk);
    total_read += chunk.len;
  }

  const written_data = target_list.written();
  const final_buf = try allocator.alloc(u8, written_data.len);
  @memcpy(final_buf, written_data);
  return final_buf;
}

/// Write to STDOUT to browser
pub fn sendMessage(message: []const u8, allocator: std.mem.Allocator, io: std.Io) !void {
  const stdout = std.Io.File.stdout();

  if (message.len <= CHUNK_SIZE) {
    var h_buf: [4]u8 = undefined;
    std.mem.writeInt(u32, &h_buf, @intCast(message.len), .little);

    // FIX 1: Write raw headers and data directly to stdout using unbuffered writeStreamingAll
    try stdout.writeStreamingAll(io, &h_buf);
    try stdout.writeStreamingAll(io, message);
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

    var chunk_buf = try allocator.alloc(u8, raw_chunk.len + 2);
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

    // FIX 2: Stream the dynamic chunk blocks unbuffered straight over the pipe descriptor boundary
    try stdout.writeStreamingAll(io, &h_buf);
    try stdout.writeStreamingAll(io, chunk_buf[0..cursor]);

    index = split_index;
  }
}
