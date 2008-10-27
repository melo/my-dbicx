package CORMTests::S::Schema::Result::User;

use strict;
use warnings;
use base qw( CORMTests::S::Schema::Base::Source );

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
  
  state => {
    data_type => 'ENUM',
    is_nullable => 1,
    extra => {
      label => 'State',
      comment => 'state of the user',
      valid_values => [
        { value => 'active',    label => 'Active'    },
        { value => 'suspended', label => 'Suspended' },
        { value => 'canceled',  label => 'Canceled'  },
      ],
    },
  },
);

__PACKAGE__->set_primary_key(qw( id ));

CORMTests::S::Schema->after_setup_do(sub {
  my $si = __PACKAGE__->source_info;
  $si->{after_setup_did_run} = 1;
});

__PACKAGE__->might_have(
  'profile' => 'CORMTests::S::Schema::Result::Profile',
  { 'foreign.user_id' => 'self.id' },
);


1;
