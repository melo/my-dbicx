package DBICx::CORM;

use warnings;
use strict;

our $VERSION = '0.01';

42; # End of DBICx::CORM

=head1 NAME

DBICx::CORM - A alternative ruleset for DBIx::Class-based ORMs


=head1 VERSION

Version 0.01


=head1 SYNOPSIS

    # This is the class you'll use as a frontend
    package My::S;
    
    use strict;
    use warnings;
    use base qw( DBIXc::CORM::Shortcuts );
    
    __PACKAGE__->setup({
      ...
    });
    
    1;
    
    # the classic Schema-based setup
    package My::Schema;
    
    use strict;
    use warnings;
    use base qw( DBICx::CORM::Schema );
    
    __PACKAGE__->load_namespaces;
    
    1;
    
    # Your table classes will be at My::Schema::Result::*
    # and My::Schema::ResultSet::*
    #
    
    package My::Schema::Result::TableA;
    
    use strict;
    use warnings;
    use base qw( DBICx::CORM::Source );
    
    # table declaration goes here
    
    1;


=head1 DESCRIPTION

TBW


=head1 AUTHOR

Pedro Melo, C<< <melo at cpan.org> >>


=head1 BUGS

Please report any bugs or feature requests to C<bug-dbicx-corm at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=DBICx-CORM>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc DBICx::CORM


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=DBICx-CORM>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/DBICx-CORM>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/DBICx-CORM>

=item * Search CPAN

L<http://search.cpan.org/dist/DBICx-CORM>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 Pedro Melo.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut
