const std = @import( "std" );
const expect = std.testing.expect;

const E = enum {
    a,
    b,
    c
};

const U = union( E ) {
   a: i32,
   b: f32,
   c
};

test "enum-union coercion" {
    const u = U{ .a = 42 };
    const e = u;

    const val = switch( u ) {
        .a => | my_int | my_int,
        .b => | my_float | my_float,
        .c => return -1,
    };

    try expect( val == 42 );
    try expect( e == E.a );
}
