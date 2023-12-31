# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/object/blank'
require 'time'

require_relative "api/version"

module Dsu
  module Api
    class Error < StandardError; end
    # Your code goes here...
  end
end
