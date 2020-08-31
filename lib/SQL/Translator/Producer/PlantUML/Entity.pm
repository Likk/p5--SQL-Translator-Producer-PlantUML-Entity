package SQL::Translator::Producer::PlantUML::Entity;
use strict;
use warnings;
use parent qw/SQL::Translator::Producer::PlantUML/;

our $VERSION = '0.01';

sub produce { return __PACKAGE__->new( translator => shift )->run; };

sub tt_schema {
    my $data = "";
    while (<DATA>) {
        last if (/__END__/);
        $data .= $_;
    }
    \$data;
}

1;

__DATA__

@startuml
[%
FOREACH table IN schema.get_tables;
  SET has_primary_key=0;
  SET has_foreign_key=0;
%]
entity [% table.name %] {
[%
  #primary_key fields.
  FOREACH field IN table.get_fields.sort();
    IF field.is_primary_key;
      has_primary_key = 1;
%]    + [% field %] [% field.data_type %] [% field.size ? '(' _ field.size _ ')' :''%]
[%  END;
    IF loop.last AND has_primary_key;
      '    ==' %]
[%  END;
  END; #primary_key end.

  # foreign_key fields.
  FOREACH constraint IN table.get_constraints;
    IF constraint.type == 'FOREIGN KEY';
      has_foreign_key=1;
      FOR field_name IN constraint.field_names;
        IF constraint.field_names.size() == 1;
%]    # [% field_name %] [FK([% constraint.reference_table %].[% constraint.reference_fields %])]
[%      ELSE;
%]    # [% field_name %] <<FK>>
[%
        END;
     END;
    END;
  END; # foreign_key end.

  # not pk, fk fields.
  FOREACH field IN table.get_fields;
    IF NOT field.is_primary_key AND
       NOT field.is_foreign_key;
%]    [% field %] [% field.data_type %] [% field.size ? '(' _ field.size _ ')' :''%]
[%  END;
  END #not pk, fk fields end. -%]
}
[% END %]
[% #reration
FOREACH table IN schema.get_tables;
  SET left_right = {};
  FOREACH cont IN table.get_constraints;
    IF cont.type.lower.match('foreign key');
      key = cont.reference_table _ '_' _ table.name;
      IF NOT left_right.${key} == 1;
%][% cont.reference_table %] ----|{ [% table.name %]
[%       left_right.${key} =1;
      END;
   END;
  END;
END; #reration end. %]
@enduml

__END__

=head1 NAME

  SQL::Translator::Producer::PlantUML::Entity - PlantUML Entity(Class Diagram Extention)-specific producer for SQL::Translator

=head1 SYNOPSIS

  use strict;
  use warnings;
  use SQL::Translator;
  use SQL::Translator::Producer::PlantUML::Entity;

  my $t = SQL::Translator->new(
      from     => 'MySQL',
      producer => 'PlantUML-Entity',
      filename => './example/multiple_foreign_key.sql',
  );

=head1 DESCRIPTION

  This module will produce text output of PlantUML Entity.
  PlantUML Entity is a Class Diagram Extention.

=head1 AUTHOR

  Likkradyus

=head1 SEE ALSO

  L<SQL::Translator::Producer::PlantUML>
 
=head1 LICENSE

  This library is free software; you can redistribute it and/or modify
  it under the same terms as Perl itself.

=cut
