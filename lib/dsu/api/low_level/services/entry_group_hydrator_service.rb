# frozen_string_literal: true

require_relative '../entry_group_model'
require_relative 'entry_hydrator_service'

module Dsu
  module Api
    module LowLevel
      module Services
        module EntryGroupModel
          class HydratorService
            def initialize(entry_group_hash:, options: {})
              raise ArgumentError, 'entry_group_hash is nil' if entry_group_hash.nil?
              raise ArgumentError, 'options is nil' if options.nil?

              @entry_group_hash = entry_group_hash
              @options = options || {}
            end

            def call
              LowLevel::EntryGroupModel.new(**hydrate)
            end

            private

            attr_reader :entry_group_hash, :options

            # Returns a Hash with :time and :entries values hydrated (i.e. Time and EntryModel objects respectively).
            def hydrate
              entry_group_hash.tap do |hash|
                hash[:time] = Time.parse(hash[:time])
                hash[:entries] =
                  EntryModel::HydratorService.new(entries_array: hash[:entries], options: options).call
              end
            end
          end
        end
      end
    end
  end
end
