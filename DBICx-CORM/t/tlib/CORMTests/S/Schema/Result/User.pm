package CORMTests::S::Schema::Result::User;

use strict;
use warnings;
use base qw( DBICx::CORM::Source );

__PACKAGE__->table('user');
__PACKAGE__->source_info({
  meta => {
    name => 'Users',
    description => 'Stores information about the registered users',
    
    groups => 'users_group',
  },
  
  shortcut => 'users',
});

__PACKAGE__->add_columns(
  id => {
    data_type   => 'INTEGER',
    is_nullable => 0,
    is_auto_increment => 1,
  },
  
  name => {
    data_type => 'VARCHAR',
    size => 100,
    is_nullable => 0,
    extra => {
      label => 'Name',
      comment => 'Name of registered user',
    },
  },
);

__PACKAGE__->set_primary_key(qw( id ));

CORMTests::S::Schema->after_setup_do(sub {
  my $si = __PACKAGE__->source_info;
  $si->{after_setup_did_run} = 1;
});

1;
