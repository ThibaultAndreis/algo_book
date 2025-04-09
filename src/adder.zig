const std = @import("std");
const testing = std.testing;
const array = @import("array.zig");

const Endian = enum { big, little };

pub fn binary_add(
    aInput: []const u1,
    bInput: []const u1,
    endian: Endian,
    allocator: std.mem.Allocator,
) ![]u1 {
    var a = aInput;
    var b = bInput;

    if (endian == .big) {
        a = try array.reverse(a, allocator);
        b = try array.reverse(b, allocator);
    }

    defer {
        if (endian == .big) {
            allocator.free(a);
            allocator.free(b);
        }
    }

    const length = @max(a.len, b.len);
    var result = try allocator.alloc(u1, length + 1);

    for (result) |*bit| {
        bit.* = 0;
    }

    for (0..length) |i| {
        const a_bit = if (i < a.len) a[i] else 0;
        const b_bit = if (i < b.len) b[i] else 0;
        const sum: u2 = @as(u2, result[i]) + @as(u2, a_bit) + @as(u2, b_bit);

        result[i] = if (@mod(sum, 2) != 0) 1 else 0;
        if (sum > 1) {
            result[i + 1] += 1;
        }
    }

    if (endian == .big) {
        array.reverseInPlace(result[0..]);
    }
    return result;
}

test "binary add - big endian" {
    const allocator = testing.allocator;
    const a = [_]u1{ 1, 0, 1, 0, 1 };
    const b = [_]u1{ 1, 1, 0, 0, 1 };
    const expected = [_]u1{ 1, 0, 1, 1, 1, 0 };

    const result = try binary_add(a[0..], b[0..], .big, allocator);
    defer allocator.free(result);

    try testing.expectEqualSlices(u1, expected[0..], result);
}

test "binary add - little endian" {
    const allocator = testing.allocator;
    const a = [_]u1{ 1, 0, 1, 0, 1 };
    const b = [_]u1{ 1, 1, 0, 0, 1 };
    const expected = [_]u1{ 0, 0, 0, 1, 0, 1 };

    const result = try binary_add(a[0..], b[0..], .little, allocator);
    defer allocator.free(result);

    try testing.expectEqualSlices(u1, expected[0..], result);
}
