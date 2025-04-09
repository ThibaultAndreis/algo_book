const std = @import("std");
const testing = std.testing;
pub fn reverse(
    bits: []const u1,
    allocator: std.mem.Allocator,
) ![]u1 {
    const len = bits.len;
    var r = try allocator.alloc(u1, len);
    for (bits, 0..) |b, i| {
        r[len - 1 - i] = b;
    }
    return r;
}

pub fn reverseInPlace(bits: []u1) void {
    for (0..(bits.len / 2)) |i| {
        const bit = bits[i];
        const a = bits[bits.len - 1 - i];
        bits[bits.len - 1 - i] = bit;
        bits[i] = a;
    }
}

test "array reverse" {
    const allocator = testing.allocator;
    const a = [_]u1{ 1, 0, 1, 1, 1 };
    const expected = [_]u1{ 1, 1, 1, 0, 1 };

    const result = try reverse(a[0..], allocator);
    defer allocator.free(result);

    try testing.expectEqualSlices(u1, expected[0..], result);
}

test "array reverse in place" {
    var a = [_]u1{ 1, 0, 1, 1, 1 };
    const expected = [_]u1{ 1, 1, 1, 0, 1 };
    reverseInPlace(a[0..]);
    try testing.expectEqualSlices(u1, &expected, &a);
}
