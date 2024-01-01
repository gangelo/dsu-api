# frozen_string_literal: true

FactoryBot.define do
  factory :migration_service, class: 'Dsu::Api::LowLevel::Services::MigrationService' do
    options { {} }

    initialize_with { Dsu::Api::LowLevel::Services::MigrationService.new(options: options) }
  end
end
