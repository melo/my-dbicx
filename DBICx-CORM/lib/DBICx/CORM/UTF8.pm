package DBICx::CORM::UTF8;

use strict;
use warnings;
use base qw( DBIx::Class );

our $VERSION = '0.1';

__PACKAGE__->load_components(qw( UTF8Columns ));

sub add_columns {
  my $class = shift;
  
  $class->next::method(@_);
  
  my @utf8_cols;

  foreach my $col ($class->columns) {
    my $info = $class->column_info($col);
    my $dt = exists $info->{data_type}? lc($info->{data_type}) : '';
    
    # Convert CHAR, VARCHAR, and ENUM
    if ($dt eq 'char' || $dt eq 'varchar' || $dt eq 'enum') {
      push @utf8_cols, $col
    }
    elsif (exists $info->{extra}{is_utf8} && $info->{extra}{is_utf8}) {
      push @utf8_cols, $col
    }
  }
  
  $class->utf8_columns(@utf8_cols) if @utf8_cols;
  
  return;
}


42; # End of X

__END__

=encoding utf8

=head1 NAME

DBICx::CORM::UTF8 - Enable use of DBIx::Class::UTF8Columns auto-magically



=head1 VERSION

Version 0.1



=head1 SYNOPSIS

    use DBICx::CORM::UTF8;

    ...


=head1 DESCRIPTION



=head1 AUTHOR

Pedro Melo, C<< <melo at cpan.org> >>



=head1 COPYRIGHT & LICENSE

Copyright 2008 EVOLUI.COM.


