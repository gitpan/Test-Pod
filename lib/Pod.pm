#$Id: Pod.pm,v 1.5 2002/09/06 04:06:12 comdog Exp $
package Test::Pod;
use strict;

=head1 NAME

Test::Pod - check for POD errors in files

=head1 SYNOPSIS

use Test::Pod;

plan tests => $num_tests;

pod_ok( $file );

=head1 DESCRIPTION

THIS IS ALPHA SOFTWARE.

Check POD files for errors or warnings in a test file, using Pod::Checker
to do the heavy lifting.

=cut

use 5.004;
use vars qw($VERSION @EXPORT);
$VERSION = '0.70';

use Carp qw(carp);
use Exporter;
use IO::Scalar;
use Pod::Checker qw(podchecker);
use Test::Builder;

my $Test = Test::Builder->new;

use constant OK       =>  0;
use constant NO_FILE  => -2;
use constant NO_POD   => -1;
use constant WARNINGS =>  1;
use constant ERRORS   =>  2;

my %Constants = qw( 
	 0 POD_OK 
	-2 NO_FILE 
	-1 NO_POD 
	 1 POD_WARNINGS 
	 2 POD_ERRORS
	);
	
sub import 
	{
    my $self = shift;
    my $caller = caller;
    no strict 'refs';
    *{$caller.'::pod_ok'}       = \&pod_ok;
    *{$caller.'::POD_OK'}       = \&OK;
    *{$caller.'::NO_FILE'}      = \&NO_FILE;
    *{$caller.'::NO_POD'}       = \&NO_POD;
    *{$caller.'::POD_WARNINGS'} = \&WARNINGS;
    *{$caller.'::POD_ERRORS'}   = \&ERRORS;

    $Test->exported_to($caller);
    $Test->plan(@_);
	}
	
=head1 FUNCTIONS

=over 4

=item pod_ok( FILENAME, [EXPECTED. [NAME] ] )

pod_ok parses the POD in filename and returns one of five
symbolic constants starting from the top of this list:

	NO_FILE       Could not find the file
	NO_POD        File had no pod directives
	POD_ERRORS	  POD had errors
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
it choose a default test name "POD test for FILENAME".

=cut

sub pod_ok
	{
	my $file     = shift;
	my $expected = shift || OK;
	my $name     = shift || "POD test for $file";
	
	my $hash = _check_pod( $file );
			
	my $status = $hash->{result};
	
	if( defined $expected and $expected eq $status )
		{
		$Test->ok( 1, $name );
		}
	elsif( $status == NO_FILE )
		{
		$Test->ok( 0, $name );
		$Test->diag( "Did not find [$file]" );
		}
	elsif( $status == OK )
		{
		$Test->ok( 1, $name );
		}
	elsif( $status == ERRORS )
		{
		$Test->ok( 0, $name );
		$Test->diag( "Pod had errors in [$file]\n",
			${$hash->{output}} );
		}
	elsif( $status == WARNINGS and $expected == ERRORS )
		{
		$Test->ok( 1, $name );
		}
	elsif( $status == WARNINGS )
		{
		$Test->ok( 0, $name );
		$Test->diag( "Pod had warnings in [$file]\n",
			${$hash->{output}} );
		}
	elsif( $status == NO_POD )
		{
		$Test->ok( 0, $name );
		$Test->diag( "Found no pod in [$file]" );
		}
	else
		{
		$Test->ok( 0, $name );
		$Test->diag( "Mysterious failure for [$file]" );
		}
	}

sub _check_pod
	{
	my $file = shift;
	
	return { result => NO_FILE } unless -e $file;

	my %hash    = ();
	my $output;
	$hash{output} = \$output;
	
	my $checker = Pod::Checker->new();
	
	# i pass it a tied filehandle because i need to fool
	# Pod::Checker into thinking it is sending the errors
	# somewhere so it will count them for me.
	tie( *OUTPUT, 'IO::Scalar', $hash{output} );	
	$checker->parse_from_file( $file, \*OUTPUT);
		
	$hash{ result } = do {
		$hash{errors}   = $checker->num_errors;
		$hash{warnings} = $checker->can('num_warnings') ?
			$checker->num_warnings : 0;
		
		   if( $hash{errors} == -1  ) { NO_POD   }
		elsif( $hash{errors}   > 0  ) { ERRORS   }
		elsif( $hash{warnings} > 0  ) { WARNINGS }
		else                          { OK }
		};
	
	return \%hash;
	}
		
=head1 AUTHOR

brian d foy, E<lt>bdfoy@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2002, brian d foy, All Rights Reserved.

You may use, modify, and distribute this package under the
same terms as Perl itself.

=cut

1;
