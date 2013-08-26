# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "el_finder_ftp/version"

Gem::Specification.new do |s|
  s.name        = "el_finder_ftp"
  s.version     = ElFinderFtp::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Chris Micacchi", "Philip Hallstrom"]
  s.email       = ["cmicacchi@solvco.com", "philip@pjkh.com"]
  s.homepage    = "https://github.com/cdmicacc/el_finder_ftp"
  s.summary     = %q{elFinder server side connector for Ruby, with an FTP backend.}
  s.description = %q{Ruby library to provide server side functionality for elFinder.  elFinder is an open-source file manager for web, written in JavaScript using jQuery UI.}
  s.license       = "MIT"

  s.rubyforge_project = "el_finder_ftp"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('image_size', '>= 1.0.0')
  s.add_dependency('net-ftp-list', '>= 3.2.5')
  s.add_dependency('browser', '>= 0.1.6')
  s.add_development_dependency('yard', '~> 0.8.1')
  s.add_development_dependency('redcarpet', '~> 2.1.1')

end
