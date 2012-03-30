use strict;
use 5.14.1;

use Data::Dumper;
use IO::String;

use MarpaX::Parser::Loader 'load_parser';

my $grammar_fh = IO::String->new(<<'INPUT');
NUMBER = /(\d+)/
SPACE  = /[ \t\r\n]/

Parser  ::= Numbers+   {{ shift; return \@_; }}
Numbers ::= NUMBER WS  {{ shift; return $_[0]; }}
WS      ::= SPACE+
WS      ::= Null
INPUT

$grammar_fh->setpos(0);

my $parser = load_parser($grammar_fh);

open my $fh, '<', 'examples/ex1.txt' or die "Can't open file";
print Dumper($parser->parse($fh));

