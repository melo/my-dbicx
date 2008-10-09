#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'DBICx::CORM' );
}

diag( "Testing DBICx::CORM $DBICx::CORM::VERSION, Perl $], $^X" );
