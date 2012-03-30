package MarpaX::Parser::Loader;

use strict;
use warnings;

use parent 'Exporter';

use IO::String;

use MarpaX::Parser::Marpa;
use MarpaX::CodeGen::SimpleLex;

our @EXPORT_OK = qw/load_parser/;

sub _open_fh_or_filename {
    my $input = shift;
    my $fh;
    if (!ref($input)) {
        open $fh, '<', $input or die "Can't load $input";
    }
    else {
        $fh = $input;
    }
    return $fh;
}

sub load_parser {
    my ($input) = @_;

    my $fh = _open_fh_or_filename($input);

    my $package = 'ANON_001';
    my $codegen = MarpaX::CodeGen::SimpleLex->new({ package => $package });

    my $parser = MarpaX::Parser::Marpa->new();
    my $parse_tree = $parser->parse($fh);

    my $code_fh = IO::String->new();
    $codegen->generate_code($code_fh, $parse_tree);

    my $code = ${$code_fh->string_ref};
    eval $code;
    die $@ if $@;
    return $package->new();
}

1;


=head1 NAME

MarpaX::Parser::Loader - Load a Marpa parser from a file

=head1 SYNOPSYS

    use MarpaX::Parser::Loader 'load_parser';
    use Data::Dumper;

    my $parser = load_parser('marpa+.mp');

    open my $fh, '<', $filename or die "Can't load $filename";
    my $ast = $parse->parse($fh);
    print Dumper($ast);

=head1 DESCRIPTION

=head1 LICENSE

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

=head1 AUTHOR

Peter Stuifzand <peter@stuifzand.eu>

=head1 COPYRIGHT

Copyright (c) 2012 Peter Stuifzand

=cut

