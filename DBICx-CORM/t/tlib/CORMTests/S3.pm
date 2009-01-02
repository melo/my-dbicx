package CORMTests::S3;

use warnings;
use strict;
use base qw( DBICx::CORM::Shortcuts );
use File::Temp;

#######################
# Setup for our schemas

__PACKAGE__->setup({
  schema_class => 'CORMTests::S::Schema',
  no_auto_shortcut => 1,
  
  env_var_name => 'MY_DEMO_MODE',
  
  modes => {
    default => {
      dsn  => 'dbi:SQLite:dbname='.File::Temp->new(UNLINK => 1, TMPDIR => 1),
      encoding => 'utf8',
    },
    
    demo => {
      dsn  => 'dbi:SQLite:dbname='.File::Temp->new(UNLINK => 1, TMPDIR => 1),
      encoding => 'utf8',
    },
  },
});

1;
