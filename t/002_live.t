# --perl--
use strict;
use warnings;
use File::Spec;
use Test::More tests => 60;
BEGIN { use_ok('Package::New') };
BEGIN { use_ok('Package::Role::ini') };

{
package #hide from index
My::Test1;
use strict;
use warnings;
use base qw{Package::New Package::Role::ini};
}

{
package #hide from index
My::Test;
use strict;
use warnings;
use base qw{Package::New Package::Role::ini};
use Path::Class qw{};
sub ini_path {Path::Class::file($0)->dir};
}

{
package #hide from index
My::Test::Sub;
use strict;
use warnings;
use base qw{My::Test};
}

{
  my $obj = My::Test1->new;
  isa_ok($obj, 'Package::New');
  isa_ok($obj, 'Package::Role::ini');
  my $path = Path::Class::file($0)->dir;

  local $@;
  eval{die('test')};
  my $error = $@;
  is($@, $error);
  $obj->{'ini'} = 'init';
  is($obj->ini_path('1'), '1');
  is($@, $error);
  is($obj->ini_path, '1');
  is($@, $error);
  is($obj->{'ini'}, undef);

  is($obj->ini_path($path), $path, 'ini_path');
  is($obj->ini_path       , $path, 'ini_path');
  is($obj->ini_file_default, 'my-test1.ini');
  is($obj->ini_file_default('my-test.ini'), 'my-test.ini');
  ok(-r $obj->ini_file);
  isa_ok($obj->ini, 'Config::IniFiles'); #new
  isa_ok($obj->ini, 'Config::IniFiles'); #cached
  is($obj->ini->val('section1', 'property1'), 'value1', '$obj->ini->value');
  is($obj->ini->val('section2', 'property3'), 'value3', '$obj->ini->value');
}

{
  
  my $obj = My::Test->new;
  isa_ok($obj, 'Package::New');
  isa_ok($obj, 'Package::Role::ini');
  is($obj->{'ini'}, undef);
  is($obj->ini_file_default_extension, 'ini'       , 'ini_file_default_extension');
  is($obj->ini_file_default,           'my-test.ini', 'ini_file_default');
  is($obj->ini_file, File::Spec->catfile($obj->ini_path, 'my-test.ini'), sprintf('ini_file: %s', $obj->ini_file));
  ok(-r $obj->ini_file);
  isa_ok($obj->ini, 'Config::IniFiles'); #new
  isa_ok($obj->ini, 'Config::IniFiles'); #cached
  is($obj->ini->val('section1', 'property1'), 'value1', '$obj->ini->value');
  is($obj->ini->val('section2', 'property3'), 'value3', '$obj->ini->value');
}

{
  my $obj = My::Test::Sub->new(ini_file_default_extension=>'conf');
  isa_ok($obj, 'Package::New');
  isa_ok($obj, 'Package::Role::ini');
  is($obj->{'ini'}, undef);
  is($obj->ini_file_default_extension, 'conf'           , 'ini_file_default_extension');
  is($obj->ini_file_default,           'my-test-sub.conf', 'ini_file_default');
  is($obj->ini_file, File::Spec->catfile($obj->ini_path, 'my-test-sub.conf'), sprintf('ini_file: %s', $obj->ini_file));
  ok(-r $obj->ini_file);
  isa_ok($obj->ini, 'Config::IniFiles'); #new
  isa_ok($obj->ini, 'Config::IniFiles'); #cached
  is($obj->ini->val('sectionA', 'propertyA'), 'valueA', '$obj->ini->value');
  is($obj->ini->val('sectionB', 'propertyC'), 'valueC', '$obj->ini->value');
}

{
  my $obj = My::Test::Sub->new();
  $obj->{'ini'} = 'init';
  is($obj->ini_file('A'), 'A');
  is($obj->ini_file, 'A');
  is($obj->{'ini'}, undef);

  $obj->{'ini'} = 'init';
  is($obj->ini_file_default('C'), 'C');
  is($obj->ini_file_default, 'C');
  is($obj->{'ini'}, undef);

  is($obj->ini_file_default(undef), 'my-test-sub.ini');

  $obj->{'ini'} = 'init';
  is($obj->ini_file_default_extension('')   , ''     , 'ini_file_default_extension');
  is($obj->ini_file_default_extension       , ''     , 'ini_file_default_extension');
  is($obj->ini_file_default(undef), 'my-test-sub.');
  is($obj->{'ini'}, undef);

  $obj->{'ini'} = 'init';
  is($obj->ini_file_default_extension(undef), undef  , 'ini_file_default_extension');
  is($obj->ini_file_default_extension       , undef  , 'ini_file_default_extension');
  is($obj->ini_file_default(undef), 'my-test-sub');
  is($obj->{'ini'}, undef);

  $obj->{'ini'} = 'init';
  is($obj->ini_file_default_extension('ext'), 'ext'  , 'ini_file_default_extension');
  is($obj->ini_file_default_extension       , 'ext'  , 'ini_file_default_extension');
  is($obj->ini_file_default(undef), 'my-test-sub.ext');
  is($obj->{'ini'}, undef);

}
