# $Id: load.t,v 1.3 2002/11/15 02:12:10 comdog Exp $

use Test::More tests => 1;

print "bail out! Test::Pod could not compile."
	unless use_ok( 'Test::Pod' );
