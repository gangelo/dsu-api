# frozen_string_literal: true

require 'dotenv/load'
require 'factory_bot'
require 'ffaker'
require 'fileutils'
require 'pry-byebug'
# require 'securerandom'
# require 'tempfile'
require 'time'
# require 'yaml'
require 'simplecov'

SimpleCov.start do
  add_filter 'spec'
end

require "dsu/api"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # FactoryBot
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
    binding.pry
    Time.zone = 'Eastern Time (US & Canada)'
  end

  config.around do |example|
    Time.use_zone(Time.zone) do
      example.run
    end
  end
end
