# $Id: all_pod_files.t,v 1.8 2004/01/26 03:50:06 petdance Exp $
use strict;

use Test::More tests => 2;

BEGIN {
    use_ok( "Test::Pod" );
}

my @files = Test::Pod::all_pod_files( "blib", "t/pod" );

# The expected files have slashes, not File::Spec separators, because
# that's how File::Find does it.
my @expected = qw(
    blib/lib/Test/Pod.pm
    t/pod/good-pod-script
    t/pod/good.pod
    t/pod/no_pod.pod
);
@files = sort @files;
@expected = sort @expected;
is_deeply( \@files, \@expected, "Got all the distro files" );
