# $Id: Makefile.PL,v 1.8 2002/09/06 07:19:21 comdog Exp $
use ExtUtils::MakeMaker;

my $tests = do {
	local @ARGV = qw(t/test_manifest);
	my $data = join " ", map {chomp; "t/$_" } <>;
	};

WriteMakefile
        (
        'NAME'      => 'Test::Pod',
        'VERSION'   => '0.71',
 		'PREREQ_PM' => {
 			'IO::Scalar'            => 0,
 			'Pod::Checker'          => 0,
 			'Test::More'            => 0,
 			'Test::Builder::Tester' => 0,
 			},
        'PM'        => 
        	{
            'lib/Pod.pm' => '$(INST_LIBDIR)/Pod.pm',
            },
 
		depend => { Makefile => 't/test_manifest' },
        test   => { TESTS => $tests },
        );

