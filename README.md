=head1 NAME

Package::Role::ini - Perl role for "ini" object the returns a Config::IniFiles object

=head1 SYNOPSIS

Configure INI file

  /etc/my-package.ini
  [section]
  entry=my_value

Package

  package My::Package;
  use base qw{Package::New Package::Role::ini};

  sub my_method {
    my $self  = shift;
    my $value = $self->ini->val('section', 'entry', 'default');
    return $value
  }

=head1 DESCRIPTION

Perl role for "ini" object that returns a Config::IniFiles object against a default INI file name and location

=head1 OBJECT ACCESSORS

=head2 ini

Returns a lazy loaded L<Config::IniFiles> object so that you can read settings from the INI file.

  my $ini = $object->ini; #isa Config::IniFiles

=head1 METHODS

=head2 ini_file

Sets or returns the profile INI filename

  my $file = $object->ini_file;
  my $file = $object->ini_file("./my.ini");

Set on construction

  my $object = My::Class->new(ini_file=>"./my.ini");

Default is the object lower case class name replacing :: with - and adding ".ini" extension. In other words, for the package My::Package the default location on Linux would be /etc/my-package.ini.

override in sub class

  sub ini_file {"/path/my.ini"};

=head2 ini_path

Sets and returns the path for the INI file.

  my $path = $object->ini_path;                  #isa Str
  my $path = $object->ini_path("../other/path"); #isa Str

Default: C:\Windows            on Windows-like systems that have Win32 installed
Default: /etc                  on systems that have /etc
Default: Sys::Path->sysconfdir on systems that Sys::Path installed
Default: .                     otherwise

override in sub class

  sub ini_path {"/my/path"};

=head2 ini_file_default

Default: lc(__PACKAGE__)=~s/::/-/g

=head2 ini_file_default_extension

Default: ini

=head1 SEE ALSO

L<Config::IniFiles>, L<Package::New>

=head1 AUTHOR

Michael R. Davis, mrdvt92

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2020 by Michael R. Davis

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.16.3 or,
at your option, any later version of Perl 5 you may have available.

