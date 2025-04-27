const std = @import( "std" );
const expect = std.testing.expect;

const SliceTypeA = extern struct {
    len: usize,
    ptr: [*]u32
};

const SliceTypeB = extern struct {
    ptr: [*]u32,
    len: usize,
};

const AnySlice = union(enum) {
    a: SliceTypeA,
    b: SliceTypeB,
    c: []const u8,
    d: []AnySlice,
};

fn withFor( any: AnySlice ) usize {
    const Tag = @typeInfo( AnySlice ).@"union".tag_type.?;
    inline for( @typeInfo( Tag ).@"enum".fields ) | field | {
        if ( field.value == @intFromEnum( any ) ) {
            return @field(any, field.name).len;
        }
    }

    unreachable;
}

fn withSwitch( any: AnySlice ) usize {
    return switch( any ) {
        inline else => | slice, tag | br: {
            std.debug.print( "Tag: {}", .{ tag } );
            std.debug.assert( tag == AnySlice.c );
            break :br slice.len;
        },
    };
}

test "inline for and inline else similarity" {
    const any = AnySlice{ .c = "hello" };
    try expect( withFor( any ) == 5 );
    try expect( withSwitch( any ) == 5 );
}
