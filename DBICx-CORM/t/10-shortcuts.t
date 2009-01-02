#!perl

use strict;
use warnings;
use lib 't/tlib';
use Test::More tests => 20;
use Test::Exception;

use_ok('CORMTests::S');

my $schema = CORMTests::S->schema;
isa_ok($schema, 'CORMTests::S::Schema');
is(scalar($schema->sources), 2);
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

use_ok('CORMTests::S2');

$cfg = CORMTests::S2->cfg;
is($cfg->{active_db_mode}, 'production');
ok(!defined($cfg->{env_var_name}));

$ENV{MY_DEMO_MODE} = 'demo';
use_ok('CORMTests::S3');

$cfg = CORMTests::S3->cfg;
is($cfg->{active_db_mode}, 'demo');
is($cfg->{env_var_name}, 'MY_DEMO_MODE');
