# $Id: all_pod_files.t,v 1.4 2004/01/10 14:48:55 petdance Exp $
use strict;

use Test::More tests => 2;
use File::Spec;

BEGIN {
    use_ok( "Test::Pod" );
}

my $tpod = File::Spec->catfile( qw( t pod ) );
my @files = Test::Pod::all_pod_files( "blib", $tpod );
my @expected = (
    File::Spec->catfile( qw( blib lib Test Pod.pm ) ),
    File::Spec->catfile( qw( t pod good.pod ) ),
    File::Spec->catfile( qw( t pod no_pod.pod ) ),
);
@files = sort @files;
@expected = sort @expected;
is_deeply( \@files, \@expected, "Got all the distro files" );
