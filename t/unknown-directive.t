# $Id: unknown-directive.t,v 1.2 2003/11/07 20:11:18 petdance Exp $
use strict;

use Test::Builder::Tester tests => 2;
use Test::More;

BEGIN {
    use_ok( 'Test::Pod' );
}

BAD: {
    my $name = 'Test name: Something not likely to accidentally occur!';
    my $file = 't/unknown-directive.pod';
    test_out( "not ok 1 - $name" );
    pod_file_ok( $file, $name );
    test_fail(-1);
    test_diag(
	"$file (9): Unknown directive: =over4",
    );
    test_test( "$name is bad" );
}