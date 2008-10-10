#!perl

use strict;
use warnings;
use Test::More 'no_plan';
use lib 't/tlib';

use_ok('CORMTests::S');

my $schema = CORMTests::S->schema;
isa_ok($schema, 'CORMTests::S::Schema');
is(scalar($schema->sources), 0);

my $cfg = CORMTests::S->cfg;
ok($cfg->{no_auto_shortcut});
is($cfg->{schema_class}, 'CORMTests::S::Schema');
is($cfg->{shortcut_class}, 'CORMTests::S');
is(scalar(keys %{$cfg->{modes}}), 2);
is($cfg->{active_db_mode}, 'default');
is($cfg->{env_var_name}, 'CORMTESTS_S_DB_MODE');

