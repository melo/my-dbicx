#!perl

use strict;
use warnings;
use lib 't/tlib';
use Test::More 'no_plan';
use Test::Exception;

use_ok('CORMTests::S');

my $schema = CORMTests::S->schema;
throws_ok sub {
  $schema->after_setup_do(sub {});
}, qr/Called 'after_setup_do' after setup done/;

throws_ok sub {
  $schema->load_classes();
}, qr/load_classes[(][)] not supported under CORM, use load_namespaces[(][)]/;
