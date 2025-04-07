const std = @import("std");
const testing = std.testing;

// bad insert sort function, working only for u8, TODO refactor this function using comptime types and function to manage other types
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
