# frozen_string_literal: true

require_relative '../color_theme_model'

module Dsu
  module Api
    module LowLevel
      module Services
        module ColorThemeModel
          class HydratorService
            def initialize(theme_name:, theme_hash:, options: {})
              raise ArgumentError, 'theme_name is nil.' if theme_name.nil?

              unless theme_hash.is_a?(Hash)
                raise ArgumentError,
                  "theme_name is the wrong object type: \"#{theme_name}\"."
              end
              raise ArgumentError, 'theme_hash is nil' if theme_hash.nil?

              unless theme_hash.is_a?(Hash)
                raise ArgumentError,
                  "theme_hash is the wrong object type: \"#{theme_hash}\""
              end
              raise ArgumentError, 'options is nil' if options.nil?
              raise ArgumentError, "options is the wrong object type:\"#{options}\"" unless options.is_a?(Hash)

              @theme_name = theme_name
              @theme_hash = theme_hash
              @options = options || {}
            end

            def call
              LowLevel::ColorThemeModel.new(theme_name: theme_name, theme_hash: hydrate)
            end

            private

            attr_reader :theme_hash, :theme_name, :options

            def hydrate
              theme_hash.each_pair do |key, value|
                next if %i[version description].include?(key)

                value.each_pair do |k, _v|
                  value[k] = value[k].to_sym
                end
              end
            end
          end
        end
      end
    end
  end
end
