#$Id: Pod.pm,v 1.9 2003/03/03 15:56:05 petdance Exp $

=head1 TODO

STUFF TO DO

Note the changes that are being made.
Note that you no longer can test for "no pod".

=cut


package Test::Pod;
use strict;

=head1 NAME

Test::Pod - check for POD errors in files

=head1 SYNOPSIS

    use Test::Pod;

    plan tests => $num_tests;

    pod_file_ok( $file, "Valid POD file" );

=head1 DESCRIPTION

THIS IS BETA SOFTWARE.

Check POD files for errors or warnings in a test file, using Pod::Simple
to do the heavy lifting.

=cut

use 5.004;
use vars qw( $VERSION );
$VERSION = '0.95';

use Exporter;
use vars qw( @EXPORT @EXPORT_OK );
@EXPORT = qw( &pod_ok &pod_file_ok );
@EXPORT_OK = @EXPORT;

use Pod::Simple;
use Test::Builder;

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

=head2 pod_ok( FILENAME [, EXPECTED [, NAME ]]  )

Note: This function is deprecated.  Use pod_file_ok() going forward.

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

=head1 AUTHOR

Currently maintained by Andy Lester, E<lt>test-pod@petdance.comE<gt>.

Originally by brian d foy, E<lt>bdfoy@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2002, Andy Lester and brian d foy, All Rights Reserved.

You may use, modify, and distribute this package under the
same terms as Perl itself.

=cut

1;
