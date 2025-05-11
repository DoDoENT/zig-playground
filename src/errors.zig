const std = @import("std");
const expect = std.testing.expect;
const maxInt = std.math.maxInt;

const ParseError = error {
    InvalidChar,
    OverFlow,
};

pub fn parseU64(buf: []const u8, radix: u8) ParseError!u64 {
    var x: u64 = 0;

    for (buf) |c| {
        const digit = charToDigit(c);

        if (digit >= radix) {
            return ParseError.InvalidChar;
        }

        // x *= radix
        var ov = @mulWithOverflow(x, radix);
        if (ov[1] != 0) return ParseError.OverFlow;

        // x += digit
        ov = @addWithOverflow(ov[0], digit);
        if (ov[1] != 0) return ParseError.OverFlow;
        x = ov[0];
    }

    return x;
}

fn charToDigit(c: u8) u8 {
    return switch (c) {
        '0'...'9' => c - '0',
        'A'...'Z' => c - 'A' + 10,
        'a'...'z' => c - 'a' + 10,
        else => maxInt(u8),
    };
}

test "parse u64" {
    const result = try parseU64("1234", 10);
    try expect(result == 1234);

    const hex = try parseU64("BABA", 16);
    try expect( hex == 0xBABA );

    _ = parseU64("BABA", 10) catch |e| blk: {
        try expect( e == error.InvalidChar );
        break :blk 0;
    };

    if ( parseU64("BABA", 10) ) |n| {
        std.debug.print( "Parsed number: {}", .{n} );
    } else |err| switch(err) {
        error.OverFlow => {
            std.debug.print( "Overlfow happened!", .{} );
        },
        error.InvalidChar => {
            std.debug.print( "\ninvalid char\n", .{} );
        }
    }
}

fn captureError(captured: *?anyerror) !void {
    errdefer |err| {
        captured.* = err;
    }
    return error.GeneralFailure;
}

test "errdefer capture" {
    var captured: ?anyerror = null;

    if (captureError(&captured)) unreachable else |err| {
        try std.testing.expectEqual(error.GeneralFailure, captured.?);
        try std.testing.expectEqual(error.GeneralFailure, err);
    }
}
