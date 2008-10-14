package CORMTests::S::Schema::Base::Source;

use strict;
use warnings;
use base qw( DBICx::CORM::Source );

__PACKAGE__->load_components(qw( +DBICx::CORM::UTF8 ));

1;
