package Lingua::JA::RelWords;
use Any::Moose;

has type => (
    is      => 'ro',
    isa     => 'Str',
    default => sub {'Google'}
);

has args => (
    is      => 'rw',
    isa     => 'HashRef',
    default => sub { {} }
);

use Any::Moose '::Util::TypeConstraints';
subtype 'LJREngine'
    => as 'Str'
    => where { $_->isa('Lingua::JA::RelWords::Engine') };

has engine => (
    is      => 'rw',
    isa     => 'LJREngine',
    handles => ['process'],
    lazy => 1,
    default => sub {
        my $self  = shift;
        my $type  = $self->type;
        my $klass = "Lingua::JA::RelWords::Engine::${type}";
        eval { Any::Moose::load_class($klass) };
        die if $@;
        $klass->new( $self->args );
    }
);

no Any::Moose '::Util::TypeConstraints';
no Any::Moose;

use Lingua::JA::RelWords::Parser;

our $VERSION = '0.00001';
our $DEBUG = $ENV{LJR_DEBUG} ? 1 : 0;

sub analyze ($) {
    my ( $self, $word ) = @_;
    my $texts = $self->engine->process($word);
    my @words = $self->summarize($texts);
    return @words;
}

sub Dump {
    return unless $DEBUG;
    require Data::Dumper;
    Data::Dumper::Dump(@_);
}

sub summarize ($) {
    my $self = shift;
    my $sum = Lingua::JA::RelWords::Parser->new;
    return $sum->get_words(shift);
}

1;
__END__

=head1 NAME

Lingua::JA::RelWords -

=head1 SYNOPSIS

  use Lingua::JA::RelWords;

  my $relwords = Lingua::JA::RelWords->new(
      type => 'Google',
      args => {
          hoge => 'fuga'
      }
  );

  $rwords = $relwords->search($word);

=head1 DESCRIPTION

Lingua::JA::RelWords is

=head1 AUTHOR

taiyoh E<lt>sun.basix@gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
