require 'bundler/setup'
Bundler.setup

require 'lin_alg_rb' # and any other gems you need

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
end