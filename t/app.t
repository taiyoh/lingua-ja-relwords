use strict;
use warnings;

use FindBin::libs;

use Test::Base qw/no_plan/;
use YAML qw/Dump/;

use_ok('Lingua::JA::RelWords');

my $relwords = Lingua::JA::RelWords->new;

my @res = $relwords->analyze('田中太陽');

print Dump \@res;
