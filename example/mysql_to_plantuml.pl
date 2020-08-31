use strict;
use warnings;
use lib qw(./lib);
use SQL::Translator;
use SQL::Translator::Producer::PlantUML::Entity;
use YAML;

my $t = SQL::Translator->new(
    from     => 'MySQL',
    producer => 'PlantUML-Entity',
    filename => './example/multiple_foreign_key.sql',
);

print $t->translate;
