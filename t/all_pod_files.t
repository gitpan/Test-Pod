# $Id: all_pod_files.t,v 1.5 2004/01/21 06:39:26 petdance Exp $
use strict;

use Test::More tests => 2;
use File::Spec;

BEGIN {
    use_ok( "Test::Pod" );
}

my $tpod = File::Spec->catfile( qw( t pod ) );
my @files = Test::Pod::all_pod_files( "blib", $tpod );

# The expected files have slashes, not File::Spec separators, because
# that's how File::Find does it.
my @expected = qw(
    blib/lib/Test/Pod.pm
    t/pod/good.pod
    t/pod/no_pod.pod
);
@files = sort @files;
@expected = sort @expected;
is_deeply( \@files, \@expected, "Got all the distro files" );
