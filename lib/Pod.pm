#$Id: Pod.pm,v 1.2 2002/08/19 05:43:13 comdog Exp $
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
$VERSION = '0.46';

use Carp qw(carp);
use Exporter;
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

=item pod_ok( FILENAME, [EXPECTED] )

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
		
=cut

sub pod_ok
	{
	my $file     = shift;
	my $expected = shift;

	my $hash = _check_pod( $file );
			
	my $status = $hash->{result};
	
	if( defined $expected and $expected eq $status )
		{
		$Test->ok( 1, "Expected [$expected], got [$status] for [$file]");
		}
	elsif( $status == NO_FILE )
		{
		$Test->ok( 0, "Did not find [$file]");
		}
	elsif( $status == OK )
		{
		$Test->ok( 1, "Pod OK in [$file]" );
		}
	elsif( $status == ERRORS )
		{
		$Test->ok( 0, "Pod had errors in [$file]" );
		}
	elsif( $status == WARNINGS and $expected == ERRORS )
		{
		$Test->ok( 1, "Pod had warnings in [$file], but that's okay" );
		}
	elsif( $status == WARNINGS )
		{
		$Test->ok( 0, "Pod had warnings in [$file]" );
		}
	elsif( $status == NO_POD )
		{
		$Test->ok( 0, "Found no pod in [$file]" );
		}
	else
		{
		$Test->ok( 0, "Mysterious failure for [$file]" );
		}
	}

sub _check_pod
	{
	my $file = shift;
	
	return { result => NO_FILE } unless -e $file;

	my %hash     = ();
	my $checker = Pod::Checker->new();
	
	# i pass it a null filehandle because i need to fool
	# Pod::Checker into thinking it is sending the errors
	# somewhere so it will count them for me.
	open NULL, ">> /dev/null";	
	$checker->parse_from_file( $file, \*NULL );
		
	$hash{ result } = do {
		$hash{errors}   = $checker->num_errors;
		$hash{warnings} = $checker->num_warnings
			if $checker->can('num_warnings');
		
		   if( $hash{errors} == -1  ) { NO_POD   }
		elsif( $hash{errors}   > 0  ) { ERRORS   }
		elsif( $hash{warnings} > 0  ) { WARNINGS }
		else                          { OK }
		};
	
	return \%hash;
	}
	
=item plan

=cut

sub plan
	{
	$Test->plan(@_);
	}
	
=head1 AUTHOR

brian d foy, E<lt>bdfoy@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2002, brian d foy, All Rights Reserved.

You may use, modify, and distribute this package under the
same terms as Perl itself.

=cut

1;
