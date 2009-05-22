use 5.008006;
use inc::Module::Install 0.78;
name 'Catalyst-Engine-Embeddable';
all_from 'lib/Catalyst/Engine/Embeddable.pm';

requires 'Catalyst::Runtime' => '5.80004';

requires 'namespace::autoclean' => '0';
requires 'URI' => '0';
requires 'HTTP::Response' => '0';
requires 'HTTP::Request' => '0';
requires 'HTTP::Body' => '0';

auto_install;
WriteAll;

