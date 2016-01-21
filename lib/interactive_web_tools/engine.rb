Gem.loaded_specs['interactive_web_tools'].dependencies.each do |d|
  require d.name
end

module InteractiveWebTools
  class Engine < ::Rails::Engine
    isolate_namespace InteractiveWebTools

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end
  end
end
