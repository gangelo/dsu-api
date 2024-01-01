# frozen_string_literal: true

require 'fileutils'
require 'json'
require_relative '../configuration_model'
require_relative '../migration_version'
require_relative '../migration_version_model'
require_relative '../modules/fileable'

module Dsu
  module Api
    module LowLevel
      module Services
        MIGRATION_VERSION_REGEX = /(\A\d+)/

        class MigrationService
          include Modules::Fileable

          def initialize(options: {})
            @options = options || {}
            @migration_version_model = LowLevel::MigrationVersionModel.new(options: options)
            @start_migration_version = @migration_version_model.version
          end

          def call
            unless self.class.run_migrations?
              puts 'Nothing to do.'
              return
            end

            run_migrations!
          end

          class << self
            def run_migrations?
              LowLevel::MigrationVersionModel.new.version < LowLevel::Migration::VERSION
            end
          end

          private

          attr_reader :migration_version_model, :options, :start_migration_version

          def run_migrations!
            puts "dsu version: #{Api::VERSION}"
            puts

            puts 'Running migrations...'
            puts

            puts "Current migration version: #{start_migration_version}"
            puts "Migrating to version: #{LowLevel::Migration::VERSION}"
            puts

            backup!
            cleanup!
            migrate!

            new_migration_version = LowLevel::MigrationVersionModel.new(version: LowLevel::Migration::VERSION).tap(&:save!).version

            puts "Migration version after migration is: #{new_migration_version}"
            puts 'Migration completed successfully.'
          rescue StandardError => e
            warn "Migration completed with errors: #{e.message}"
            back_trace = e.backtrace.filter_map do |line|
              line if line.include?('dsu-api')
            end.join("\n\t")
            warn "Backtrace:\n\t#{back_trace}"
          end

          def backup!
            backup_config!
            puts

            backup_entry_groups!
            puts

            backup_themes!
            puts
          end

          def backup_config!
            puts 'Backing up config...'
            if File.exist?(config_path)
              backup_path = File.join(current_backup_folder, config_file_name)
              puts "Backing up #{config_path} to #{backup_path}..."
              FileUtils.cp(config_path, backup_path)
            else
              puts 'No config to backup.'
            end
          end

          def backup_entry_groups!
            puts 'Backing up entry_model groups...'
            if Dir.exist?(entries_folder)
              backup_folder = File.join(current_backup_folder, File.basename(entries_folder))
              puts "Backing up #{entries_folder} to #{backup_folder}..."
              FileUtils.mkdir_p(backup_folder)
              FileUtils.cp_r("#{entries_folder}/.", backup_folder)
            else
              puts 'No entries to backup.'
            end
          end

          def backup_themes!
            puts 'Backing up themes...'
            if Dir.exist?(themes_folder)
              backup_folder = File.join(current_backup_folder, File.basename(themes_folder))
              puts "Backing up #{themes_folder} to #{backup_folder}..."
              FileUtils.mkdir_p(backup_folder)
              FileUtils.cp_r("#{themes_folder}/.", backup_folder)
            else
              puts 'No entries to backup.'
            end
          end

          def before_migration_version
            @before_migration_version ||= migration_version_instance.version
          end

          def cleanup!
            puts 'Cleaning up old config file...'
            File.delete(config_path) if File.file?(config_path)
            puts 'Done.'
            puts

            puts 'Cleaning up old entries...'
            entry_files = Dir.glob(File.join(entries_folder, '*'))
            entry_files.each do |entry_file|
              File.delete(entry_file) if File.file?(entry_file)
            end
            puts 'Done.'
            puts

            puts 'Cleaning up old themes...'
            theme_files = Dir.glob(File.join(themes_folder, '*'))
            theme_files.each do |theme_file|
              File.delete(theme_file) if File.file?(theme_file)
            end
            puts 'Done.'
            puts
          end

          def create_backup_folder!
            FileUtils.mkdir_p(backup_folder(version: current_migration_version))
          end

          def current_backup_folder
            @current_backup_folder ||= begin
              create_backup_folder!
              backup_folder(version: current_migration_version)
            end
          end

          def current_migration_version
            migration_version_instance.version
          end

          # Migrate

          def migrate!
            FileUtils.mkdir_p(dsu_folder)
            FileUtils.mkdir_p(themes_folder)
            FileUtils.mkdir_p(entries_folder)

            migrate_themes!
            migrate_config!
            migrate_entry_groups!
          end

          def migrate_config!
            puts 'Migrating config...'
            LowLevel::ConfigurationModel.new.save!
            puts 'Done.'
          end

          def migrate_entry_groups!
            puts 'Migrating entry_model groups...'
            # source_folder = File.join(seed_data_folder, 'entries')
            # puts "Copying entries from #{source_folder} to #{entries_folder}..."
            # FileUtils.cp_r("#{source_folder}/.", entries_folder)
            # puts 'Done.'
            description = "Migrated DSU to version #{LowLevel::Migration::VERSION}"
            entry_model = LowLevel::EntryModel.new(description: description)
            LowLevel::EntryGroupModel.new(time: Time.now, entries: [entry_model]).save!
            puts 'Done.'
          end

          def migrate_themes!
            puts 'Migrating themes...'
            source_folder = File.join(seed_data_folder, 'themes')
            puts "Copying themes from #{source_folder} to #{themes_folder}..."
            FileUtils.cp_r("#{source_folder}/.", themes_folder)
            puts 'Done.'
          end

          def migration_version_instance
            @migration_version_instance ||= LowLevel::MigrationVersionModel.new
          end
        end
      end
    end
  end
end
