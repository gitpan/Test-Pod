# $Id: Makefile.PL,v 1.10 2002/12/04 01:05:15 comdog Exp $
use ExtUtils::MakeMaker;

sub ExtUtils::MM_Any::test_via_harness
		{
		my($self, $perl, $tests) = @_;

		return qq|\t$perl "-MTest::Manifest" | .
			qq|"-e" "run_t_manifest(\$(TEST_VERBOSE), '\$(INST_LIB)', | .
			qq|'\$(INST_ARCHLIB)')"\n|;
		}

WriteMakefile
        (
        'NAME'           => 'Test::Pod',
        'VERSION_FROM'   => 'lib/Pod.pm',
 		'PREREQ_PM'      => {
 			'IO::Scalar'            => '0',
 			'Pod::Checker'          => '1.4',
 			'Test::Manifest'        => '0.9',
 			'Test::More'            => '0',
 			'Test::Builder::Tester' => '0',
 			},
        'PM'             => 
        	{
            'lib/Pod.pm' => '$(INST_LIBDIR)/Pod.pm',
            },
		'MAN3PODS'		 => {
		'lib/Pod.pm' => '$(INST_MAN3DIR)/Test::Pod.3',
			},

		clean => { FILES => 'Test-Pod-*' },
        );

