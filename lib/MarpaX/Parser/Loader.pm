use strict;
use warnings;
package MarpaX::Parser::Loader;

1;


=head1 NAME

MarpaX::Parser::Loader - Load a Marpa parser from a file

=head1 SYNOPSYS

    use MarpaX::Parser::Loader;
    use Data::Dumper;

    my $loader = MarpaX::Parser::Loader->new();
    my $parser = $loader->load('marpa+.mp');

    my $ast = $parse->parse($fh);
    print Dumper($ast);

=head1 DESCRIPTION

=head1 AUTHOR

Peter Stuifzand <peter@stuifzand.eu>

=head1 COPYRIGHT


=cut

