$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "interaction_web_tools/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "interaction_web_tools_rails"
  s.version     = InteractionWebTools::VERSION
  s.authors     = ["Folkefinans ruby team"]
  s.email       = ["stanislav.gorski@gmail.com"]
  s.homepage    = "https://github.com/folkia/interaction_web_tools_rails"
  s.summary     = "InteractionWebTools."
  s.description = "Description of InteractionWebTools."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.test_files = Dir['spec/**/*']

  s.add_dependency "rails", "~> 4.2.5"
  s.add_dependency 'jbuilder', '~> 2.4.0'
  s.add_dependency 'coffee-rails', '~> 4.1.1'
  s.add_dependency 'jquery-rails', '~> 4.1.0'
  s.add_development_dependency 'rspec-rails', '~> 3.0'
end
