Gem.loaded_specs['inin_chat'].dependencies.each do |d|
  require d.name
end

module IninChat
  class Engine < ::Rails::Engine
    isolate_namespace IninChat

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end
  end
end
