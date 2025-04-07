//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
const testing = std.testing;

pub fn insertion_sort(arr: []u8) void {
    for (1..arr.len) |i| {
        const currVal = arr[i];
        var prev = i - 1;
        while (arr[prev] > currVal) {
            arr[prev + 1] = arr[prev];
            if (prev > 0) {
                prev = prev - 1;
                arr[prev + 1] = currVal;
            } else {
                arr[prev] = currVal;
                break;
            }
        }
    }
}

test "insertion_sort" {
    var input = [_]u8{ 5, 2, 4, 6, 1, 3 };
    const output = [_]u8{ 1, 2, 3, 4, 5, 6 };
    insertion_sort(&input);
    try testing.expectEqualSlices(u8, &input, &output);
}
