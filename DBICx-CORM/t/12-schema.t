#!perl

use strict;
use warnings;
use lib 't/tlib';
use Test::More 'no_plan';
use Test::Exception;

use_ok('CORMTests::S');

my $schema = CORMTests::S->schema;
lives_ok sub { $schema->deploy }, 'Deploy success';

my $user = CORMTests::S->users->create({
  name => 'Pedro Melo',
});
$user = CORMTests::S->users->create({
  name => 'Pedro Melo Jr',
});

$schema->dbh_do(sub {
  my (undef, $dbh) = @_;
  
  my $sth = $dbh->prepare(q{SELECT COUNT(*) FROM user});
  $sth->execute;
  my ($count) = $sth->fetchrow_array;
  
  is($count, 2, 'Proper number of users');
});
