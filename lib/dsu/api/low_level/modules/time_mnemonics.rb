# frozen_string_literal: true

module Dsu
  module Api
    module LowLevel
      module Modules
        module TimeMnemonics
          # TODO: I18n.
          TODAY = %w[n today].freeze
          TOMORROW = %w[t tomorrow].freeze
          YESTERDAY = %w[y yesterday].freeze

          RELATIVE_REGEX = /\A[+-]\d+\z/
        end
      end
    end
  end
end
