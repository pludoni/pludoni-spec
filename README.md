# Pludoni Spec helper

Add this line to your application's Gemfile:

    group :development, :test do
      gem 'pludoni-spec'
    end

And then your spec-helper:

    ENV["RAILS_ENV"] ||= 'test'
    require "pludoni/coverage"
    require File.expand_path("../../config/environment", __FILE__)
    require 'rspec/rails'
    require "pludoni/spec-helper"

    RSpec.configure do |config|
      config.fixture_path = "#{::Rails.root}/spec/fixtures"
      config.infer_base_class_for_anonymous_controllers = false
      config.order = "random"
      config.use_transactional_fixtures = true
    end


Gem provides a lot of test helpers


TODO documentation of those
