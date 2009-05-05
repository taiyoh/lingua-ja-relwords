use strict;
use warnings;

use Test::Base qw/no_plan/;

use FindBin::libs;

use_ok('Lingua::JA::RelWords::Parser');

my $parser = Lingua::JA::RelWords::Parser->new;

$parser->get_words(do {
    open my $f, '<', 't/data/kyoto.txt';
    my $t = '';
    $t .= $_ for (<$f>);
    close $f;
    $t;
});
