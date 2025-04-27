const std = @import("std");
const expect = std.testing.expect;
const print = std.debug.print;

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try stdout.print("Hello, {s}\n", .{"world"});

    try bw.flush(); // don't forget to flush!

    {
        var iter = std.process.ArgIterator.init();
        while ( iter.next() ) |element| {
            print("parameter found: {s}\n", .{element} );
        }
    }

    {
        const bla: u8 = undefined;
        std.debug.print("A weird int: {}\n", .{bla});
    }

    {
        const tuple = .{ 1, 2, 30 };

        const x, const y, const z = tuple;
        print("destructured: x = {}, y = {}, z = {}\n", .{ x, y, z });
    }

    {
        const bla = -std.math.nan(f32);
        print("nan: {}\n", .{bla});
        if (std.math.isSignalNan(bla)) {
            print("it was a signaling nan\n", .{});
        } else {
            print("it was NOT a signaling nan\n", .{});
        }
    }
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.getLast());

    const num = list.items[0];

    try std.testing.expectEqual(42, num);

    for (1..55) |i| {
        try list.append(@intCast(i));
    }
    try std.testing.expectEqual(42, num);
}

test "some enum" {
    const val = enum(u32) { a, b = 8, c, d = 90, e };

    try expect(@intFromEnum(val.a) == 0);
    try expect(@intFromEnum(val.c) == 9);
    try expect(@intFromEnum(val.e) == 91);
}
