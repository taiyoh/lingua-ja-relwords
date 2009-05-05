package Lingua::JA::RelWords::Engine::Google;

use Any::Moose;
extends 'Lingua::JA::RelWords::Engine::SE';

has links => ( is => 'rw', isa => 'Xpath', default => sub {'//li[@class="g"]'} );
has title => ( is => 'rw', isa => 'Xpath', default => sub {'//h3[@class="r"]'} );
has desc  => ( is => 'rw', isa => 'Xpath', default => sub {'//div[@class="s"]'} );

has num => ( is => 'ro', isa => 'Int', default => sub {50} );
has hl  => ( is => 'ro', isa => 'Str', default => sub {'ja'} );
has lr  => ( is => 'ro', isa => 'Str', default => sub {'ja'} );
has ie  => ( is => 'ro', isa => 'Str', default => sub {'utf8'} );
has oe  => ( is => 'ro', isa => 'Str', default => sub {'utf8'} );

no Any::Moose;

use URI;

sub get_url {
    my $self = shift;
    my $q    = shift;
    my $uri  = URI->new('http://www.google.co.jp/search');
    Lingua::JA::RelWords::Dump($self, $q);
    $uri->query_form(
        {   q => $q,
            map { $_ => $self->$_ } qw/num hl lr ie oe/
        }
    );
    $uri;
}

sub get_plain {
    my $self   = shift;
    my $result = shift;
    my @texts;
    for ( @{ $result->{links} } ) {
        my $title = $_->{title} || '';
        my $desc = $_->{desc} || '';
        $desc =~ s/<cite>(.+?)$//;
        $desc =~ s!<b>\.\.\.</b>!!g;
        $desc =~ s!<(.*?)>!!g;
        push @texts, $title, $desc;
    }
    join ', ', @texts;
}

1;
