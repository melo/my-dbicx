package CORMTests::S::Schema::Result::Profile;

use strict;
use warnings;
use base qw( CORMTests::S::Schema::Base::Source );

__PACKAGE__->table('profile');
__PACKAGE__->source_info({
  meta => {
    name => 'Profiles',
    description => 'Stores optional profile fields for each user',
    
    groups => 'users_group',
  },
  
  shortcut => 'profiles',
});

__PACKAGE__->add_columns(
  user_id => {
    data_type   => 'INTEGER',
    is_nullable => 0,
  },
  
  city => {
    data_type   => 'VARCHAR',
    size        => 100,
    is_nullable => 0,
    extra => {
      label   => 'City',
      comment => 'City where the user lives',
    },
  },
  
  country => {
    data_type   => 'VARCHAR',
    size        => 100,
    is_nullable => 0,
    extra => {
      label   => 'Country',
      comment => 'Country where the user lives',
    },
  },
  
  gender => {
    data_type => 'ENUM',
    default   => 'unknowns',
    extra     => {
      # valid_values => {
      #   { value => 'unknown', label => 'Unknown' },
      #   { value => 'female',  label => 'Female'  },
      #   { value => 'male',    label => 'Male'    },
      # },
    },
  },
);

__PACKAGE__->set_primary_key(qw( user_id ));

__PACKAGE__->belongs_to(
  'user' => 'CORMTests::S::Schema::Result::User',
  { 'foreign.id' => 'self.user_id' },
);

1;
