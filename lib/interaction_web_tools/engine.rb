Gem.loaded_specs['interaction_web_tools_rails'].dependencies.each do |d|
  require d.name
end

module InteractionWebTools
  class Engine < ::Rails::Engine
    isolate_namespace InteractionWebTools

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: "spec/factories"
    end
  end
end
