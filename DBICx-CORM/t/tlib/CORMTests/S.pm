package CORMTests::S;

use warnings;
use strict;
use base qw( DBICx::CORM::Shortcuts );
use File::Temp;

#######################
# Setup for our schemas

__PACKAGE__->setup({
  schema_class => 'CORMTests::S::Schema',
  no_auto_shortcut => 1,
  
  modes => {
    default => {
      dsn  => 'dbi:sqlite:dbname='.File::Temp->new(UNLINK => 1, TMPDIR => 1),
      encoding => 'utf8',
    },
    
    production => {
      dsn  => 'dbi:sqlite:dbname='.File::Temp->new(UNLINK => 1, TMPDIR => 1),
      encoding => 'utf8',
    },
  },
});

1;