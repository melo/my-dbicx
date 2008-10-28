#!perl

use strict;
use warnings;
use lib 't/tlib';
use Test::More 'no_plan';
use Test::Exception;
use Test::Deep;

use_ok('CORMTests::S');

my $schema = CORMTests::S->schema;
lives_ok sub { $schema->deploy }, 'Deploy success';

my $user = CORMTests::S->users->create({
  name  => 'Pedro Melo',
  state => 'active',
});
ok($user);
is($user->state, 'active');
is($user->state_fmt, 'Active');

my $vv = $user->state_valid_values;
cmp_deeply($vv, {
  active    => 'Active',
  suspended => 'Suspended',
  canceled  => 'Canceled',
});

my $info = $user->result_source->column_info('state');
cmp_deeply($info->{extra}{list}, [ 'active', 'suspended', 'canceled' ]);
