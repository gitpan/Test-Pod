# $Id: bad.t,v 1.1 2003/03/03 20:12:54 petdance Exp $
use strict;

use Test::Builder::Tester tests => 2;
use Test::More;

BEGIN {
    use_ok( 'Test::Pod' );
}

BAD: {
    my $name = 'Test name: Something not likely to accidentally occur!';
    my $file = 't/pod/bad.pod';
    test_out( "not ok 1 - $name" );
    pod_file_ok( $file, $name );
    test_fail(-1);
    test_diag(
	"t/pod/bad.pod (9): Unknown directive: =over4",
    );
    test_test( 'Bad POD is bad' );
}
