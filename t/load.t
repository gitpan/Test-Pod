# $Id: load.t,v 1.4 2002/12/04 01:04:38 comdog Exp $

use Test::More tests => 1;

use Pod::Checker;

my $version = Pod::Checker->VERSION;

print STDERR "\nI see you are using Pod::Checker $version\n";

print "bail out! Test::Pod could not compile."
	unless use_ok( 'Test::Pod' );
