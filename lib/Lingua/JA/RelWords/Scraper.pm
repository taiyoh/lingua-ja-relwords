package Lingua::JA::RelWords::Scraper;

use Web::Scraper;

sub get {
    my $self = shift;
    scraper {
        process $self->links, 'links[]' => scraper {
            process $self->title, 'title' => 'TEXT';
            process $self->desc,  'desc'  => 'HTML';
        };
    };
}

1;
