# frozen_string_literal: true

FactoryBot.define do
  factory :entry_group, class: 'Dsu::Api::LowLevel::EntryGroupModel' do
    transient do
      # Use this if you want to control the entries added
      # to this entry group.
      entries { [] }
    end

    time { nil }
    version { Dsu::Api::LowLevel::EntryGroupModel::VERSION }

    # Use this trait if you want to simply add entries to
    # this entry group and do not care about the entry
    # attributes used.
    trait :with_entries do
      entries { build_list(:entry, 2) }
    end

    initialize_with do
      new(time: time, entries: entries, version: version)
    end

    after(:create) do |entry_group, _evaluator|
      entry_group.write!
    end

    after(:build) do |entry_group, evaluator|
      evaluator.entries&.each_with_index do |entry, index|
        unless entry.is_a?(Dsu::Api::LowLevel::EntryModel)
          raise 'Entry must be an instance of Dsu::Api::LowLevel::EntryModel'
        end

        entry_group.entries[index] = entry.clone
      end
    end
  end
end
