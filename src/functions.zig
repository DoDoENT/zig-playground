const std = @import( "std" );
const expect = std.testing.expect;

fn add(x: anytype, y: anytype) @TypeOf(x+y) {
    return x + y;
}

test "adding" {
    try expect( add( 2, 3 ) == 5 );
    try expect( add( 2.2, 3.3 ) == 5.5 );
    const a = comptime add( 7, 3 );
    try expect( @TypeOf( a ) == comptime_int );

    const b = comptime add( 7.2, 3.2 );
    try expect( @TypeOf( b ) == comptime_float );

    if ( add( 7, 3 ) != 10 ) {
        @compileError( "no no" );
    }

    try expect( @typeInfo( @TypeOf( add ) ).@"fn".params[ 0 ].is_generic );
}
