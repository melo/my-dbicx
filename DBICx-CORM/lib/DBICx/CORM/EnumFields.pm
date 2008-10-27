package DBICx::CORM::EnumFields;

use strict;
use warnings;
use Carp qw( croak );

sub add_columns {
  my $class = shift;
  
  $class->next::method(@_);

  # search ENUM fields, try to create list of valid options
  foreach my $name ($class->columns) {
    my $info = $class->column_info($name);
    next unless exists $info->{extra}{valid_values};
    
    my @values;
    my $extra = $info->{extra};
    my $vv = $extra->{valid_values};
    if (ref($vv) eq 'HASH') {
      @values = keys %$vv;
      $extra->{valid_values_to_str} = $vv;
    }
    elsif (ref($vv) eq 'ARRAY') {
      my %map;
      foreach my $item (@$vv) {
        my ($value, $label) = ($item->{value}, $item->{label});
        push @values, $value;
        $map{$value} = $label;
      }
      $extra->{valid_values_to_str} = \%map;
    }
    else {
      croak("Invalid value for extra.valid_values in field '$name', ");
    }
    
    $info->{extra}{valid_values_list} = \@values;
    
    {
      no strict 'refs';
      no warnings 'redefine';
      *{"${class}::${name}_fmt"} = sub {
        my $self = shift;
        
        my $value = $self->get_column($name);
        return undef unless defined($value);

        my $info = $self->column_info($name);
        return undef unless exists $info->{extra}{valid_values_to_str}{$value};
        return $info->{extra}{valid_values_to_str}{$value};
      };
      
      *{"${class}::${name}_valid_values"} = sub {
        my $self = shift;
        
        my $info = $self->column_info($name);
        my $values = $info->{extra}{valid_values_to_str};
        
        return wantarray? %$values : { %$values };
      };
      
    }
  }
  
  return;
}

1;