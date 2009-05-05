package Lingua::JA::RelWords::Engine::YahooBOSS;
use Any::Moose;
with 'Lingua::JA::RelWords::Engine::SE';

has links => ( is => 'rw', isa => 'Xpath', default => sub {'//li[@class="g"]'} );
has title => ( is => 'rw', isa => 'Xpath', default => sub {'//h3[@class="r"]'} );
has desc  => ( is => 'rw', isa => 'Xpath', default => sub {'//div[@class="s"]'} );

has appid  => ( is => 'ro', isa => 'Str', required => 1 );
has count  => ( is => 'ro', isa => 'Int', default => sub {50} );
has lang   => ( is => 'ro', isa => 'Str', default => sub {'jp'} );
has region => ( is => 'ro', isa => 'Str', default => sub {'jp'} );
has format => ( is => 'ro', isa => 'Str', default => sub {'xml'} );

no Any::Moose;

use URI::Escape::XS;

sub get_url {
    my ( $self, $keyword ) = @_;

    utf8::decode($keyword);
    $keyword = encodeURIComponent($keyword);
    my $guri = URI->new("http://boss.yahooapis.com/ysearch/web/v1/${keyword}");
    $guri->query_form( { map { $_ => $self->$_ } qw/count lang region form appid/ } );
    $guri;
}


1;
