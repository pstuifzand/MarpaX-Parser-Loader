use strict;
use 5.14.1;

use Data::Dumper;
use IO::String;

use MarpaX::Parser::Loader 'load_parser';

my $grammar_fh = IO::String->new(<<'GRAMMAR');
NUMBER = /(\d+)/
SPACE  = /[ \t\r\n]/

Parser     ::= Expression+                      {{ shift; return \@_; }}
Expression ::= WS Term WS $+ WS Expression WS   {{ shift; return $_[1] + $_[5]; }}
Expression ::= WS Term WS $- WS Expression WS   {{ shift; return $_[1] - $_[5]; }}
Expression ::= WS Term WS                       {{ shift; return $_[1];         }}
Term       ::= WS Factor WS $* WS Term WS       {{ shift; return $_[1] * $_[5]; }}
Term       ::= WS Factor WS $/ WS Term WS       {{ shift; return $_[1] / $_[5]; }}
Term       ::= WS Factor                        {{ shift; return $_[1]; }}
Factor     ::= WS $( Expression $)              {{ shift; return $_[2]; }}
Factor     ::= WS NUMBER WS                     {{ shift; return $_[1]; }}
WS         ::= SPACE+
WS         ::= Null
GRAMMAR

$grammar_fh->setpos(0);

my $parser = load_parser($grammar_fh);

open my $fh, '<', 'examples/ex1.txt' or die "Can't open file";

print Dumper($parser->parse($fh));

