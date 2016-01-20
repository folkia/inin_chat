$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "inin_chat/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "inin_chat"
  s.version     = IninChat::VERSION
  s.authors     = ["Folkefinans ruby team"]
  s.email       = ["stanislav.gorski@gmail.com"]
  s.homepage    = "https://github.com/folkia/inin_chat"
  s.summary     = "TODO: Summary of IninChat."
  s.description = "TODO: Description of IninChat."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.test_files = Dir['spec/**/*']

  s.add_dependency "rails", "~> 4.2.5"
  s.add_dependency 'jbuilder', '~> 2.4.0'
  s.add_development_dependency 'rspec-rails', '~> 3.0'
end
