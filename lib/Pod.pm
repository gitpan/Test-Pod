#$Id: Pod.pm,v 1.15 2003/11/10 15:09:00 petdance Exp $

package Test::Pod;

use strict;

=head1 NAME

Test::Pod - check for POD errors in files

=head1 SYNOPSIS

Test::Pod lets you check the validity of a POD file, and report its
results in standard Test::Simple fashion.

    use Test::Pod;
    plan tests => $num_tests;
    pod_file_ok( $file, "Valid POD file" );

Module authors can include the following in a F<t/pod.t> file and
have Test::Pod automatically find and check all POD files in a module
distribution:

    use Test::More;
    eval "use Test::Pod 1.00";
    plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;
    all_pod_files_ok();

=head1 DESCRIPTION

THIS IS BETA SOFTWARE.

Check POD files for errors or warnings in a test file, using Pod::Simple
to do the heavy lifting.

=cut

use 5.004;
use vars qw( $VERSION );
$VERSION = '1.02';

use Exporter;
use vars qw( @EXPORT @EXPORT_OK );
@EXPORT = qw( &pod_ok &pod_file_ok &all_pod_files_ok );
@EXPORT_OK = @EXPORT;

use Pod::Simple;
use Test::Builder;
use File::Find;

my $Test = Test::Builder->new;

use constant OK       =>  0;
use constant NO_FILE  => -2;
use constant NO_POD   => -1;
use constant WARNINGS =>  1;
use constant ERRORS   =>  2;

sub import {
    my $self = shift;
    my $caller = caller;
    no strict 'refs';
    *{$caller.'::pod_ok'}       = \&pod_ok;
    *{$caller.'::pod_file_ok'}  = \&pod_file_ok;
    *{$caller.'::all_pod_files_ok'}  = \&all_pod_files_ok;

    *{$caller.'::POD_OK'}       = \&OK;
    *{$caller.'::NO_FILE'}      = \&NO_FILE;
    *{$caller.'::NO_POD'}       = \&NO_POD;
    *{$caller.'::POD_WARNINGS'} = \&WARNINGS;
    *{$caller.'::POD_ERRORS'}   = \&ERRORS;

    $Test->exported_to($caller);
    $Test->plan(@_);
}

=head1 FUNCTIONS

=head2 pod_file_ok( FILENAME[, TESTNAME ] )

C<pod_file_ok()> will okay the test if the POD parses correctly.  Certain
conditions are not reported yet, such as a file with no pod in it at all.

When it fails, C<pod_file_ok()> will show any pod checking errors as
diagnostics.

The optional second argument TESTNAME is the name of the test.  If it
is omitted, C<pod_file_ok()> chooses a default test name "POD test
for FILENAME".

=cut

sub pod_file_ok {
    my $file = shift;
    my $name = shift || "POD test for $file";

    if ( !-f $file ) {
	$Test->ok( 0, $name );
	$Test->diag( "$name does not exist" );
	return;
    }
    
    my $checker = Pod::Simple->new;
    
    $checker->output_string( \my $trash ); # Ignore any output
    $checker->parse_file( $file );
    unless ( $Test->ok( !$checker->any_errata_seen, $name ) ) {
	my $lines = $checker->{errata};
	for my $line ( sort { $a<=>$b } keys %$lines ) {
	    my $errors = $lines->{$line};
	    $Test->diag( "$file ($line): $_" ) for @$errors;
	}
    }
} # pod_file_ok

=head2 all_pod_files_ok( [@files] )

Checks all the files in C<@files> for valid POD.  It runs
L<all_pod_files()> on each file, and calls the C<plan()> function for you
(one test for each function), so you can't have already called C<plan>.

If C<@files> is empty or not passed, the function finds all POD files in
the F<blib> directory.  A POD file is one that ends with F<.pod>, F<.pl>
and F<.pm>, or any file where the first line looks like a shebang line.

If you're testing a module, just make a F<t/pod.t>:

    use Test::More;
    eval "use Test::Pod 1.00";
    plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;
    all_pod_files_ok();

=cut

sub all_pod_files_ok {
    my @files = @_ ? @_ : all_pod_files( "blib" );

    $Test->plan( tests => scalar @files );

    foreach my $file ( @files ) {
	pod_file_ok( $file, $file );
    }
}

sub all_pod_files {
    my @files;

    find( sub {
	return unless -f $_;

	my $hit = 0;
	$hit = 1 if /\.p(l|m|od)$/;
	if ( !$hit ) {
	    local *FH;
	    open FH, $_ or die "Can't check $_";
	    my $first = <FH>;
	    close FH;

	    $hit = 1 if $first && ($first =~ /^#!.*perl/);
	}

	push( @files, $File::Find::name ) if $hit;
    }, "blib" );

    return @files;
}

sub valid_file {
    my $file = shift;

    return 0 unless -f $_;

    warn "Checking $_ as $file\n";


    return 0;
}

=head2 pod_ok( FILENAME [, EXPECTED [, NAME ]]  )

Note: This function is B<deprecated>.  Use pod_file_ok() going forward.

pod_ok parses the POD in filename and returns one of five
symbolic constants starting from the top of this list:

	NO_FILE       Could not find the file
	NO_POD        File had no pod directives
	POD_ERRORS    POD had errors
	POD_WARNINGS  POD had warnings
	POD_OK	      No errors or warnings

pod_ok will okay the test if you don't specify any expected
result and it finds no errors or warnings, or if you specify
what you expect and it finds that condition.  For instance, if
you can live with warnings,

	pod_ok( $file, POD_WARNINGS );

When it fails, pod_ok will show any pod checking errors.

The optional third argument NAME is the name of the test
which pod_ok passes through to Test::Builder.  Otherwise,
it chooses a default test name "POD test for FILENAME".

=cut

sub pod_ok {
    my $filename = shift;
    my $expected = shift; # No longer used

    pod_file_ok( $filename, @_ );
    $Test->diag( "NOTE: pod_ok() is deprecated" );
} # pod_ok


=head1 SOURCE AVAILABILITY

This source is part of a SourceForge project which always has the
latest sources in CVS, as well as all of the previous releases.

    https://sourceforge.net/projects/brian-d-foy/

If, for some reason, I disappear from the world, one of the other
members of the project can shepherd this module appropriately.

=head1 TODO

STUFF TO DO

Note the changes that are being made.
Note that you no longer can test for "no pod".

=head1 AUTHOR

Currently maintained by Andy Lester, C<< <test-pod@petdance.com> >>.

Originally by brian d foy, C<< <bdfoy@cpan.org> >>.

=head1 COPYRIGHT

Copyright 2003, Andy Lester and brian d foy, All Rights Reserved.

You may use, modify, and distribute this package under the
same terms as Perl itself.

=cut

1;
