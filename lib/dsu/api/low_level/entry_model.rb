# frozen_string_literal: true

require 'active_model'
require_relative 'modules/descriptable'
require_relative 'validators/description_validator'

module Dsu
  module Api
    module LowLevel
      # This class represents something someone might want to share at their
      # daily standup (DSU).
      class EntryModel
        include ActiveModel::Model
        include Modules::Descriptable

        validates_with Validators::DescriptionValidator

        attr_reader :description, :options

        def initialize(description:, options: {})
          raise ArgumentError, 'description is the wrong object type' unless description.is_a?(String)

          # Make sure to call the setter method so that the description is cleaned up.
          self.description = description
          @options = options || {}
        end

        class << self
          def clean_description(description)
            return if description.nil?

            description.strip.gsub(/\s+/, ' ')
          end
        end

        def description=(description)
          @description = self.class.clean_description description
        end

        def to_h
          { description: description }
        end

        # Override == and hash so that we can compare EntryModel objects based
        # on description alone. This is useful for comparing entries in
        # an array, for example.
        def ==(other)
          return false unless other.is_a?(EntryModel)

          description == other.description
        end
        alias eql? ==

        def hash
          description.hash
        end
      end
    end
  end
end
