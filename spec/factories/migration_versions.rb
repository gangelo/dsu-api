# frozen_string_literal: true

FactoryBot.define do
  factory :migration_version, class: 'Dsu::Api::LowLevel::MigrationVersionModel' do
    version { nil }
    options { {} }

    trait :with_current_version do
      version { Dsu::Api::LowLevel::Migration::VERSION }
    end

    initialize_with { Dsu::Api::LowLevel::MigrationVersionModel.new(version: version, options: options) }
  end
end
