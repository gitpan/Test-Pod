# $Id: pod_ok.t,v 1.2 2002/09/06 04:06:12 comdog Exp $
use strict;

use Test::Builder::Tester tests => 5;
use Test::Pod;

{
my $name = 'test ok';
test_out( map "ok $_ - $name", 1 .. 9 );
pod_ok( "t/pod/good.pod",         undef,       , $name );
pod_ok( "t/pod/good.pod",         POD_OK       , $name );
pod_ok( "t/pod/good.pod",         POD_WARNINGS , $name );
pod_ok( "t/pod/good.pod",         POD_ERRORS   , $name );

pod_ok( "t/pod/bad.pod",          POD_ERRORS   , $name );

pod_ok( "t/pod/warning.pod",      POD_WARNINGS , $name );
pod_ok( "t/pod/warning.pod",      POD_ERRORS   , $name );

pod_ok( "t/pod/no_pod.pod",       NO_POD       , $name );

pod_ok( "t/pod/doesnt_exist.pod", NO_FILE      , $name );
test_test();
}

{
my $file = 't/pod/good.pod';
test_out( "ok 1 - POD test for $file" );
pod_ok( $file );
test_test();
}

{
my $file = 't/pod/bad.pod';
test_out( "not ok 1 - POD test for $file" );
pod_ok( $file );
test_fail(-1);
test_diag( "Pod had errors in [$file]",
	"*** ERROR: =over on line 9 without closing =back (at head1) at line 13 in file $file",
	"$file has 1 pod syntax error.",
 );
test_test();
}

{
my $file = 't/pod/doesnt_exist.pod';
test_out( "not ok 1 - POD test for $file" );
pod_ok( $file );
test_fail(-1);
test_diag( "Did not find [$file]" );
test_test();
}

{
my $file = 't/pod/no_pod.pod';
test_out( "not ok 1 - POD test for $file" );
pod_ok( $file );
test_fail(-1);
test_diag( "Found no pod in [$file]" );
test_test();
}
