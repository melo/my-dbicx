#!perl -T

use strict;
use warnings;
use Test::More 'no_plan';
use lib 't/tlib';

use_ok('CORMTests::S');

my $schema = CORMTests::S->schema;
isa_ok($schema, 'CORMTests::S::Schema');
is(scalar($schema->sources), 0);


