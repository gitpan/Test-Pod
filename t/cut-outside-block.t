# $Id: cut-outside-block.t,v 1.2 2003/03/04 17:23:13 petdance Exp $
use strict;

use Test::Builder::Tester tests => 2;
use Test::More;

BEGIN {
    use_ok( 'Test::Pod' );
}

BAD: {
    my $file = 't/cut-outside-block.pod';
    test_out( "not ok 1 - POD test for $file" );
    pod_file_ok( $file );
    test_fail(-1);
    test_diag(
	"$file (5): =cut found outside a pod block.  Skipping to next block."
    );
    test_test( '$file is bad' );
}
