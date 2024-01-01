# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/time'
require 'i18n'

I18n.load_path += Dir[File.join(__dir__, '../locales/**/*', '*.yml')]
# I18n.default_locale = :en # (note that `en` is already the default!)

# Dir.glob("#{__dir__}/api/low_level/core/ruby/**/*.rb").each do |file|
#   require file
# end

# Array.include(Dsu::Api::LowLevel::Core::Ruby::WrapAndJoin)
# Hash.include(Dsu::Api::LowLevel::Core::Ruby::ColorThemeColors)
# Hash.include(Dsu::Api::LowLevel::Core::Ruby::ColorThemeMode)

Dir.glob("#{__dir__}/api/**/*.rb").each do |file|
  require file
end

Array.include(Dsu::Api::LowLevel::Core::Ruby::WrapAndJoin)
Hash.include(Dsu::Api::LowLevel::Core::Ruby::ColorThemeColors)
Hash.include(Dsu::Api::LowLevel::Core::Ruby::ColorThemeMode)

require_relative 'api/env'
require 'pry-byebug' if Dsu.env.local?

unless Dsu.env.local?
  if Dsu::Api::LowLevel::Services::MigrationService.run_migrations?
    begin
      Dsu::Api::LowLevel::Services::MigrationService.new.call
    rescue StandardError => e
      puts I18n.t('migrations.error.failed', message: e.message)
      exit 1
    end
  end
  # TODO: Hack. Integrate this into the migration service
  # so that this runs only if the migration version changes.
  %w[light.json christmas.json].each do |theme_file|
    destination_theme_file_path = File.join(Dsu::Api::LowLevel::Modules::Fileable.themes_folder, theme_file)
    next if File.exist?(destination_theme_file_path)

    source_theme_file_path = File.join(Dsu::Api::LowLevel::Modules::Fileable.seed_data_folder, 'themes', theme_file)
    FileUtils.cp(source_theme_file_path, destination_theme_file_path)
    puts I18n.t('migrations.information.theme_copied', from: source_theme_file_path, to: destination_theme_file_path)
  end
end
