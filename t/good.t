# $Id: good.t,v 1.2 2003/02/28 23:32:05 petdance Exp $
use strict;

use Test::Builder::Tester tests => 2;
use Test::More;

BEGIN {
    use_ok( 'Test::Pod' );
}

GOOD: {
    my $name = 'Test name: Blargo!';
    test_out( map "ok $_ - $name", 1 .. 1 );
    pod_file_ok( "t/pod/good.pod", $name );
    test_test( 'Handles good.pod OK' );
}
