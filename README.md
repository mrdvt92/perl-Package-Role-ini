# NAME

Package::Role::ini - Perl role for "ini" object that returns a Config::IniFiles object

# SYNOPSIS

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

# DESCRIPTION

Perl role for "ini" object that returns a Config::IniFiles object against a default INI file name and location

# OBJECT ACCESSORS

## ini

Returns a lazy loaded [Config::IniFiles](https://metacpan.org/pod/Config::IniFiles) object so that you can read settings from the INI file.

    my $ini = $object->ini; #isa Config::IniFiles

# METHODS

## ini\_file

Sets or returns the profile INI filename

    my $file = $object->ini_file;
    my $file = $object->ini_file("./my.ini");

Set on construction

    my $object = My::Class->new(ini_file=>"./my.ini");

Default is the object lower case class name replacing :: with - and adding ".ini" extension. In other words, for the package My::Package the default location on Linux would be /etc/my-package.ini.

override in sub class

    sub ini_file {"/path/my.ini"};

## ini\_path

Sets and returns the path for the INI file.

    my $path = $object->ini_path;                  #isa Str
    my $path = $object->ini_path("../other/path"); #isa Str

Default: C:\\Windows            on Windows-like systems that have Win32 installed
Default: /etc                  on systems that have /etc
Default: Sys::Path->sysconfdir on systems that Sys::Path installed
Default: .                     otherwise

override in sub class

    sub ini_path {"/my/path"};

## ini\_file\_default

Default: lc(\_\_PACKAGE\_\_)=~s/::/-/g

## ini\_file\_default\_extension

Default: ini

# SEE ALSO

[Config::IniFiles](https://metacpan.org/pod/Config::IniFiles), [Package::New](https://metacpan.org/pod/Package::New)

# AUTHOR

Michael R. Davis, mrdvt92

# COPYRIGHT AND LICENSE

Copyright (C) 2020 by Michael R. Davis

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.16.3 or,
at your option, any later version of Perl 5 you may have available.
