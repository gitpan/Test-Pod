# $Id: Makefile.PL,v 1.7 2002/09/06 04:06:12 comdog Exp $
use ExtUtils::MakeMaker;

my $tests = do {
	local @ARGV = qw(t/test_manifest);
	my $data = join " ", map {chomp; "t/$_" } <>;
	};

WriteMakefile
        (
        'NAME'      => 'Test::Pod',
        'VERSION'   => '0.70',
 		'PREREQ_PM' => {
 			'IO::Scalar'     => 0,
 			'Pod::Checker'   => 0,
 			'Test::More'     => 0,
 			},
        'PM'        => 
        	{
            'lib/Pod.pm' => '$(INST_LIBDIR)/Pod.pm',
            },
 
		depend => { Makefile => 't/test_manifest' },
        test   => { TESTS => $tests },
        );

