# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

# Prevent database truncation if the environment is production
# abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'spec_helper'

require File.expand_path('../../spec/dummy/config/environment', __FILE__)

require 'rspec/rails'
require 'capybara/rspec'
require 'vcr'

RSpec.configure do |config|
  config.include Capybara::RSpecMatchers
  config.infer_spec_type_from_file_location!
end
