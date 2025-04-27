const std = @import("std");
const expect = std.testing.expect;
const print = std.debug.print;

test "defer unwinding" {
    print("\n", .{});

    defer {
        print("1\n", .{});
    }
    defer {
        print("2\n", .{});
    }
    if (false) {
        // defers are not run if they are never executed.
        defer {
            print("3\n", .{});
        }
    }
}
