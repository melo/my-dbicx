package DBICx::CORM::Shortcuts;

use strict;
use warnings;
use Carp qw( croak );

##################################
# Connection and environment setup

{
  # hidden in a inner scope
  my %cfgs;
  my %schemas;
  
  sub setup {
    my ($class, $info) = @_;
    
    $cfgs{$class} = $info;
    $info->{shortcut_class} = $class;

    $class->_setup_db_mode($info);
    $class->_create_shortcuts($info) unless $info->{skip_shortcuts};

    return;
  }
  
  sub cfg {
    my ($class) = @_;
    
    croak("Shortcut class '$class' didn't call setup()")
      unless exists $cfgs{$class};
    return $cfgs{$class};
  }
  
  sub schema {
    my ($class) = @_;
    
    my $info    = $class->cfg;
    my $s_class = $info->{schema_class};

    my $db_mode = $info->{active_db_mode};
    croak("Asked for non-existing DB mode '$db_mode' (DB '$class')")
       unless exists $info->{modes}{$db_mode};
    
    my $schema = $schemas{$s_class};
    if (!$schema) {
      my $connect_info = $info->{modes}{$db_mode};
      my @conn = (
        $connect_info->{dsn},
        $connect_info->{user},
        $connect_info->{pass},
        { AutoCommit => 1, RaiseError => 1 },
      );
      if ($connect_info->{utf8}) {
        if ($connect_info->{dsn} =~ /:MySQL:/) {
          push @conn, { on_connect_do => [q{SET NAMES 'utf8'}] };
        }
      }
      $schema = $schemas{$s_class} = $s_class->connection(@conn);
    }
  
    return $schema;
  }
}

# Init shortcuts and db_mode in a separate scope
{
  sub _create_shortcuts {
    my ($class, $info) = @_;
    my $schema_class = $info->{schema_class};
    
    eval "require $schema_class;";
    croak("Error while loading class '$schema_class': $@") if $@;

    SOURCE:
    foreach my $source_name ($schema_class->sources) {
      my $s_info = $schema_class->source($source_name)->source_info;

      next SOURCE if $s_info->{skip_shortcut};
      
      my $method = $info->{shortcut};
      next SOURCE if !$method && $info->{no_auto_shortcut};
      
      if (!$method) {
        $method = $source_name;
        $method =~ s/.+::(.+)$/$1/; # deal with nested sources
        $method =~ s/([a-z])([A-Z])/${1}_$2/g;
        $method = lc($method);
      }

      croak("shortcut '$method' clashes with same named in '$class'")
        if $class->can($method);

      no strict 'refs';
      *{"$class\::$method"} = sub {
        my $rs = shift->schema->resultset($source_name);
        return $rs unless @_;                # no parameters, just a resultset
        return $rs->find(@_) if !ref($_[0]); # use find if it looks like PK
        return $rs->search(@_);              # search for all other cases
      };
    }
  }
  
  sub _setup_db_mode {
    my ($class, $info) = @_;
    
    my $env_var = $info->{env_var_name};
    if (!$env_var) {
      $env_var = uc($class);
      $env_var =~ s/::/_/g;
      $env_var .= '_DB_MODE';
      $info->{env_var_name} = $env_var;
    }
    
    my $db_mode = $ENV{$env_var};
    $db_mode = 'default' unless $db_mode;
    
    $info->{active_db_mode} = $db_mode;
    
    return;
  }
}


################
# DBIC shortcuts

sub txn_do    { my $class = shift; return $class->schema->txn_do(@_)          }
sub dbh_do    { my $class = shift; return $class->schema->storage->dbh_do(@_) }
sub resultset { my $class = shift; return $class->schema->resultset(@_)       }

1;
