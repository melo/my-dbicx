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
  name => 'Pedro Melo',
});
isa_ok($user, 'CORMTests::S::Schema::Result::User');

my $si = $user->result_source->source_info;
ok($si->{after_setup_did_run}, 'After setup hooks are working');

is($user->my_schema, $schema);
is($user->my_source_name, 'User');

my $user_copy = $user->my_self_resultset->first;
is($user_copy->id, $user->id);

CORMTests::S->users->create({
  name => 'Pedro Melo Jr',
});

$user_copy = $user->my_resultset->search({ name => 'Pedro Melo Jr' })->first;
isnt($user_copy->id, $user->id);
is($user_copy->id, $user->id + 1);


# try some transactions
$user->txn_do(sub {
  $user->update({ name => 'Antonio Cunha' });
});
$user->discard_changes;
is($user->name, 'Antonio Cunha');

dies_ok sub {
  $user->txn_do(sub {
    $user->update({ name => 'Pedro Melo' });
    die;
  });
};
$user->discard_changes;
is($user->name, 'Antonio Cunha');


# Direct dbi access
$user->dbh_do(sub {
  my (undef, $dbh) = @_;
  
  $dbh->do(q{
    UPDATE user
       SET name = 'Pedro Melo'
     WHERE id = ?
  }, undef, $user->id);
});
$user->discard_changes;
is($user->name, 'Pedro Melo');

$user->create_related('profile', {
  city    => 'Porto',
  country => 'Portugal',
  gender  => 'male',
});

my $profile = $user->profile;
is($profile->city,    'Porto');
is($profile->country, 'Portugal');
is($profile->gender,  'male');

my $u8c = $profile->utf8_columns;
cmp_deeply($u8c, {
  'country' => 1,
  'city'    => 1,
  'gender'  => 1
});
