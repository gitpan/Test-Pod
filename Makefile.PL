# $Id: Makefile.PL,v 1.6 2002/09/04 19:53:46 comdog Exp $
use ExtUtils::MakeMaker;

my $tests = do {
	local @ARGV = qw(t/test_manifest);
	my $data = join " ", map {chomp; "t/$_" } <>;
	};

WriteMakefile
        (
        'NAME'      => 'Test::Pod',
        'VERSION'   => '0.63',
 		'PREREQ_PM' => {
 			'IO::Null'       => undef,
 			'Pod::Checker'   => undef,
 			'Test::More'     => undef,
 			},
        'PM'        => 
        	{
            'lib/Pod.pm' => '$(INST_LIBDIR)/Pod.pm',
            },
 
		depend => { Makefile => 't/test_manifest' },
        test   => { TESTS => $tests },
        );

