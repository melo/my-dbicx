package DBICx::CORM::Source;

use warnings;
use strict;
use base qw( DBIx::Class );

__PACKAGE__->load_components(qw( Core ));


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

sub my_self_resultset {
  my $self = shift;
  
  return $self->result_source->resultset->search($self->ident_condition);
}

sub my_resultset {
  my $self = shift;
  
  return $self->result_source->resultset;
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


###########
# SQLT hook

sub sqlt_deploy_hook {
  my ($class, $table) = @_;
  my $sinfo = $class->source_info;
  
  # Make sure we have the proper Type and Charset for MySQL tables
  $table->extra( 'mysql_table_type' => $sinfo->{mysql_table_type})
    if exists $sinfo->{mysql_table_type};
  $table->extra( 'mysql_charset' => $sinfo->{encoding})
    if exists $sinfo->{encoding};
  $table->extra( 'mysql_charset' => $sinfo->{mysql_charset})
    if exists $sinfo->{mysql_charset};

  # Allows the definition of extra indexes  
  my $extra_indexes = [];
  $extra_indexes = $sinfo->{extra_indexes}
    if exists $sinfo->{extra_indexes};
  foreach my $index (@$extra_indexes) {
    $table->add_index(%$index);
  }

  return;
}


1;