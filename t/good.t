# $Id: good.t,v 1.3 2003/12/28 06:11:54 petdance Exp $
use strict;

use Test::Builder::Tester tests => 3;
use Test::More;

BEGIN {
    use_ok( 'Test::Pod' );
}

my $filename = File::Spec->catdir( qw( t pod good.pod ) );

GOOD: {
    my $name = 'Test name: Blargo!';
    test_out( map "ok $_ - $name", 1 .. 1 );
    pod_file_ok( $filename, $name );
    test_test( 'Handles good.pod OK' );
}

DEFAULT_NAME: {
    test_out( map "ok $_ - POD test for $filename", 1 .. 1 );
    pod_file_ok( $filename );
    test_test( 'Handles good.pod OK, and builds default name OK' );
}
