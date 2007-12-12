use 5.008008;
use ExtUtils::MakeMaker;
WriteMakefile
  (
   NAME              => 'Catalyst::Engine::Embeddable',
   VERSION_FROM      => 'lib/Catalyst/Engine/Embeddable.pm',
   PREREQ_PM         => { Catalyst::Runtime => 5.7011, URI => 0, HTTP::Response => 0, HTTP::Request => 0, HTTP::Body => 0 },
   ABSTRACT_FROM  => 'lib/Catalyst/Engine/Embeddable.pm',
   AUTHOR         => 'Daniel Ruoso <daniel.ruoso@verticalone.pt>',
  );
