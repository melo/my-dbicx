#!perl

use strict;
use warnings;
use lib 't/tlib';
use Test::More 'no_plan';
use Test::Exception;

use_ok('CORMTests::S');

my $schema = CORMTests::S->schema;
isa_ok($schema, 'CORMTests::S::Schema');
is(scalar($schema->sources), 1);
lives_ok sub { $schema->deploy }, 'Deploy success';

can_ok('CORMTests::S', 'users');
my $users_rs = CORMTests::S->users;
isa_ok($users_rs, 'DBIx::Class::ResultSet');

ok(!defined(CORMTests::S->users(1)));
is(CORMTests::S->users({ id => 2 })->count, 0);

my $cfg = CORMTests::S->cfg;
ok($cfg->{no_auto_shortcut});
is($cfg->{schema_class}, 'CORMTests::S::Schema');
is($cfg->{shortcut_class}, 'CORMTests::S');
is(scalar(keys %{$cfg->{modes}}), 2);
is($cfg->{active_db_mode}, 'default');
is($cfg->{env_var_name}, 'CORMTESTS_S_DB_MODE');

