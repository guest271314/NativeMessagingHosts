//usr/bin/env -S /home/user/bin/zig run "$0"
// Zig Native Messaging host
// guest271314, TerenceTux (https://ziggit.dev/u/terencetux) 2-14-2026, 6-13-2026
// Source: QuickJS Native Messaging host https://github.com/guest271314/NativeMessagingHosts/blob/main/nm_qjs_64.js
// Zig 0.16.0
// zig build-exe nm_zig_stable.zig -O ReleaseSmall
// zig build-exe nm_zig_stable.zig -target wasm32-wasi -O ReleaseSmall

const std = @import("std");

fn getMessage(reader: *std.Io.Reader, alloc: std.mem.Allocator) ![]u8 {
  const header = try reader.takeInt(u32, .native);
  const output = try alloc.alloc(u8, header);
  errdefer alloc.free(output);
  try reader.readSliceAll(output);
  return output;
}

fn sendMessage(writer: *std.Io.Writer, message: []const u8) !void {
  if (message.len > 1024 * 1024) {
    var from_index: usize = 1024 * 1024 - 8;
    var index: usize = 0;

    while (index < message.len) {
      const i = std.mem.findScalarPos(u8, message, from_index, ',') orelse message.len;
      var part = message[index..i];
      index = i;
      from_index += 1024 * 1024 - 8;

      const start = part[0];
      const end = part[part.len - 1];

      var append: ?u8 = null;
      var prepend: ?u8 = null;

      if (start == '[' and end != ',' and end != ']') {
        append = ']';
      } else if (start == ',' and end != ']') {
        part = part[1..];
        prepend = '[';
        append = ']';
      } else if (start == ',' and end == ']') {
        part = part[1..];
        prepend = '[';
      }

      var length: usize = part.len;
      if (prepend != null) {
        length += 1;
      }
      if (append != null) {
        length += 1;
      }

      try writer.writeInt(u32, @intCast(length), .native);

      if (prepend) |char| {
        try writer.writeByte(char);
      }
      try writer.writeAll(part);
      if (append) |char| {
        try writer.writeByte(char);
      }
    }
  } else {
    try writer.writeInt(u32, @intCast(message.len), .native);
    try writer.writeAll(message);
  }
  try writer.flush();
}

pub fn main(init: std.process.Init) !void {
  const alloc = init.gpa;
  const io = init.io;

  const stdin = std.Io.File.stdin();
  var stdin_buffer: [4096]u8 = undefined;
  var stdin_reader = stdin.reader(io, &stdin_buffer);

  const stdout = std.Io.File.stdout();
  var stdout_buffer: [4096]u8 = undefined;
  var stdout_writer = stdout.writer(io, &stdout_buffer);

  while (true) {
    const message = try getMessage(&stdin_reader.interface, alloc);
    defer alloc.free(message);
    try sendMessage(&stdout_writer.interface, message);
  }
}
