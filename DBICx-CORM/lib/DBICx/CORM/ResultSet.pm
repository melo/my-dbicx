package DBICx::CORM::ResultSet;

use warnings;
use strict;
use base qw( DBIx::Class::ResultSet );
use DBICx::CORM::Logger qw( get_logger );

############################
# meta-info about the source

sub my_schema {
  my $self = shift;
  
  return $self->result_source->schema;
}

sub my_source_name {
  my $self = shift;
  
  return $self->result_source->source_name;
}


##################
# Useful shortcuts

sub txn_do {
  my $self = shift;
  
  return $self->my_schema->txn_do(@_);
}

sub dbh_do {
  my $self = shift;
  
  return $self->my_schema->storage->dbh_do(@_);
}


####################################
# Defaults for order_by and prefetch

sub search_rs {
  my ($self, @rest) = @_;
  
  my $rs = $self->next::method(@rest);
  my $info = $self->result_source->source_info;

  # Default prefetch
  if (exists $info->{default_prefetch}) {
    $rs = $rs->search_rs({}, { prefetch => $info->{default_prefetch} })
      unless $rs->{attrs}{prefetch};
  }

  # Default order_by
  if (exists $info->{default_order_by}) {
    $rs = $rs->search_rs({}, { order_by => "$rs->{attrs}{alias}.$info->{default_order_by}" })
      unless $rs->{attrs}{order_by};
  }

  return $rs;
}

1;
