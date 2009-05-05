package Lingua::JA::RelWords::Parser;

use strict;
use warnings;

use Lingua::JA::Summarize;

sub new {
    my ( $class, $arg ) = @_;

    my $kwd_arg = {
        maxwords  => delete $arg->{maxwords}  || 50,
        threshold => delete $arg->{threshold} || 1.4
    };

    my $s = Lingua::JA::Summarize->new(
        {
            charset       => 'utf8',
            mecab_charset => 'utf8',
            default_cost      => 1.8,
            singlechar_factor => 0.3,
            %$arg
        }
    );

    bless { _summarize => $s, _kwd_arg => $kwd_arg }, $class;
}

sub get_words {
    my $self  = shift;
    my $texts = shift;

    my $s = $self->{_summarize};
    $s->analyze($texts);
    my @words = grep { $_ ne '' } $s->keywords($self->{_kwd_arg});

    return wantarray? @words : [@words];
}

1;
