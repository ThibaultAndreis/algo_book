const std = @import("std");
const testing = std.testing;

const Errors = error{NotFound};

pub fn linear(haystack: []const u8, needle: u8) !usize {
    var i: usize = 0;
    while (i < haystack.len) : (i += 1) {
        if (haystack[i] == needle) {
            return i;
        }
    }
    return Errors.NotFound;
}

test "linear search" {
    const input = [_]u8{ 1, 2, 3, 4 };
    try testing.expect((try linear(&input, 2)) == 1);
    const te = linear(&input, 5);
    try testing.expectError(Errors.NotFound, te );
}
