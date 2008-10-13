package DBICx::CORM::Schema;

use warnings;
use strict;
use base qw/DBIx::Class::Schema/;


############################################
# Hook system to run code after Schema setup

__PACKAGE__->mk_classdata('corm_after_setup_do' => []);

sub load_classes {
  my $class = shift;
  
  $class->next::method(@_);
  $class->_run_after_setup_do_callbacks;
  
  return;
}

sub load_namespaces {
  my $class = shift;
  
  $class->next::method(@_);
  $class->_run_after_setup_do_callbacks;
  
  return;
}

sub after_setup_do {
  my $class = shift;
  
  my $cbs = $class->corm_after_setup_do;
  if (defined $cbs) {
    push @$cbs, @_;
  }
  else {
    foreach my $cb (@_) {
      $cb->();
    }
  }
  
  return;
}

sub _run_after_setup_do_callbacks {
  my $class = shift;
  
  my $cbs = $class->corm_after_setup_do;
  return unless defined $cbs;
  
  foreach my $cb (@$cbs) {
    $cb->();
  }

  $class->corm_after_setup_do(undef);
  
  return;
}


############################
# Some DBIx::Class shortcuts

sub dbh_do {
  my $self = shift;

  return $self->storage->dbh_do(@_)
}

1;
