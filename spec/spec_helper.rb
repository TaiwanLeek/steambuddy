# frozen_string_literal: true

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'vcr'
require 'webmock'

require_relative '../require_app'
require_app

require_relative 'test_config'

CORRECT = YAML.safe_load(File.read('spec/fixtures/steam_results.yml'))

CASSETTES_FOLDER = 'spec/fixtures/cassettes'
CASSETTE_FILE = 'steam_api'
