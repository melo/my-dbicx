package DBICx::CORM::Schema;

use warnings;
use strict;
use Carp qw( croak );
use base qw/DBIx::Class::Schema/;


############################################
# Hook system to run code after Schema setup

__PACKAGE__->mk_classdata('corm_after_setup_do' => []);
__PACKAGE__->mk_classdata('corm_after_setup_done');

sub load_classes {
  croak("load_classes() not supported under CORM, use load_namespaces(), ");
}

sub load_namespaces {
  my $class = shift;
  
  $class->next::method(@_);
  $class->_run_after_setup_do_callbacks;
  
  return;
}

sub after_setup_do {
  my $class = shift;
  
  croak("Called 'after_setup_do' after setup done, ")
    if $class->corm_after_setup_done;

  my $cbs = $class->corm_after_setup_do;
  push @$cbs, @_;
  
  return;
}

sub _run_after_setup_do_callbacks {
  my $class = shift;
  
  my $cbs = $class->corm_after_setup_do;
  foreach my $cb (@$cbs) {
    $cb->();
  }

  $class->corm_after_setup_done(1);
  
  return;
}


############################
# Some DBIx::Class shortcuts

sub dbh_do {
  my $self = shift;

  return $self->storage->dbh_do(@_)
}

1;
