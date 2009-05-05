package Lingua::JA::RelWords::Engine::SE;

use Any::Moose;

use Any::Moose '::Util::TypeConstraints';
subtype 'Xpath'
    => as 'Str'
    => where { $_ =~ /^\/[\/a-zA-Z0-9="'@()]+/ }
    => message {"This xpath ($_) is invalid"};

has ua => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {
        'User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ja; rv:1.9.0.9) Gecko/2009042114 Ubuntu/9.04 (jaunty) Firefox/3.0.9'
    }
);

has user_agent => (
    is       => 'ro',
    isa      => 'LWP::UserAgent',
    lazy     => 1,
    weak_ref => 1,
    default  => sub {
        my $self = shift;
        use LWP::UserAgent;
        my $ua = LWP::UserAgent->new;
        $ua->agent( $self->ua );
        $ua;
    }
);

no Any::Moose '::Util::TypeConstraints';
no Any::Moose;

use Lingua::JA::RelWords::Scraper;

sub process ($) {
    my $self   = shift;
    my $word   = shift;

    my $result = $self->fetch($word);
    my $text = $self->get_plain($result);
    return $text;
}

sub get_scraper {
    my $self = shift;
    Lingua::JA::RelWords::Scraper::get($self);
}

sub fetch {
    my $self = shift;
    my $word = shift;

    my $scraper = $self->get_scraper;
    $scraper->user_agent( $self->user_agent );
    my $uri = $self->get_url($word);
    return $scraper->scrape($uri);
}

sub get_plain {
    my $self   = shift;
    my $result = shift;
    my @texts;
    push @texts, $_->{title}, $_->{desc} for ( @{ $result->{links} } );
    join ', ', @texts;
}

1;
