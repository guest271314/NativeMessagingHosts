//usr/bin/env -S /home/user/bin/zig run "$0"
// Zig Native Messaging host
// guest271314, 3-20-2026
// Source: QuickJS Native Messaging host https://github.com/guest271314/native-messaging-quickjs/nm_qjs.js
// Zig 0.15.2
// zig-stable build-exe nm_zig_stable.zig -O ReleaseSmall
// zig-stable build-exe nm_zig_stable.zig -target wasm32-wasi -O ReleaseSmall

const std = @import("std");

const CHUNK_SIZE = 1024 * 1024; // 1 MiB
const COMMA = 44;
const OPEN_BRACKET = 91;
const CLOSE_BRACKET = 93;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    while (true) {
        // Read the full message (up to 64 MiB)
        const message = getMessage(allocator) catch |err| {
            if (err == error.EndOfStream) break;
            return err;
        };
        defer allocator.free(message);

        // Process and send back in 1 MiB chunks
        if (message.len <= CHUNK_SIZE) {
            try sendMessage(message);
        } else {
            var index: usize = 0;
            while (index < message.len) {
                var split_index: usize = index + CHUNK_SIZE - 8;

                if (split_index >= message.len) {
                    split_index = message.len;
                } else {
                    // Find next safe comma to split JSON array
                    if (std.mem.indexOfScalarPos(u8, message, split_index, COMMA)) |pos| {
                        split_index = pos;
                    } else {
                        split_index = message.len;
                    }
                }

                const raw_chunk = message[index..split_index];
                if (raw_chunk.len == 0) break;

                const start_byte = raw_chunk[0];
                const end_byte = raw_chunk[raw_chunk.len - 1];

                const needs_open = (start_byte == COMMA);
                const needs_close = (end_byte != CLOSE_BRACKET);
                const body_src_offset: usize = if (needs_open) 1 else 0;
                const body_len = raw_chunk.len - body_src_offset;
                
                // Calculate size for the chunk: Body + Brackets
                const total_payload_len = body_len + 
                    (if (needs_open or (index == 0 and start_byte != OPEN_BRACKET)) @as(usize, 1) else @as(usize, 0)) + 
                    (if (needs_close) @as(usize, 1) else @as(usize, 0));

                const out_buf = try allocator.alloc(u8, total_payload_len);
                defer allocator.free(out_buf);

                var cursor: usize = 0;
                if (needs_open or (index == 0 and start_byte != OPEN_BRACKET)) {
                    out_buf[cursor] = OPEN_BRACKET;
                    cursor += 1;
                }

                @memcpy(out_buf[cursor .. cursor + body_len], raw_chunk[body_src_offset..]);
                cursor += body_len;

                if (needs_close) {
                    out_buf[cursor] = CLOSE_BRACKET;
                }

                try sendMessage(out_buf);
                index = split_index;
            }
        }
    }
}

pub fn getMessage(allocator: std.mem.Allocator) ![]u8 {
    const stdin = std.fs.File.stdin();
    
    // Read 4-byte header
    var h_buf: [4]u8 = undefined;
    const h_read = try stdin.readAll(&h_buf);
    if (h_read < 4) return error.EndOfStream;

    const msg_len = std.mem.readInt(u32, &h_buf, .little);
    const buf = try allocator.alloc(u8, msg_len);
    errdefer allocator.free(buf);
    
    // Fill buffer exactly
    _ = try stdin.readAll(buf);
    return buf;
}

pub fn sendMessage(message: []const u8) !void {
    const stdout = std.fs.File.stdout();
    
    // Native Messaging: 4-byte little-endian length prefix
    var h_buf: [4]u8 = undefined;
    std.mem.writeInt(u32, &h_buf, @intCast(message.len), .little);
    
    // Raw writeAll ensures the header and message are sent to the OS immediately
    try stdout.writeAll(&h_buf);
    try stdout.writeAll(message);
}


