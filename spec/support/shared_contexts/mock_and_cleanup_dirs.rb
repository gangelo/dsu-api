# frozen_string_literal: true

RSpec.shared_context 'when dir mock and cleanup is needed' do
  before do
    # Mock Dir.home and Dir.tmpdir to return the temporary directories
    allow(Dir).to receive_messages(home: temp_folder, tmpdir: temp_folder)
    allow(Tempfile).to receive(:new).with('dsu').and_return(temp_file)

    FileUtils.mkdir_p(Dsu::Api::LowLevel::Modules::Fileable.root_folder)

    dsu_folder = File.join(temp_folder, 'dsu')
    FileUtils.mkdir_p(dsu_folder)
    allow(Dsu::Api::LowLevel::Modules::Fileable).to receive_messages(migration_version_folder: dsu_folder, migration_version_path: File.join(dsu_folder, Dsu::Api::LowLevel::Modules::Fileable::MIGRATION_VERSION_FILE_NAME))

    FileUtils.mkdir_p(Dsu::Api::LowLevel::Modules::Fileable.config_folder)
    FileUtils.mkdir_p(Dsu::Api::LowLevel::Modules::Fileable.entries_folder)
    FileUtils.mkdir_p(Dsu::Api::LowLevel::Modules::Fileable.themes_folder)

    create(:color_theme)
  end

  after do
    # Clean up the files and directories created within the temporary directory.
    FileUtils.rm_rf(File.join(temp_folder, 'dsu'))
    FileUtils.rm_rf(File.join(temp_folder, '.dsu'))
  end

  let(:temp_folder) { Dir.tmpdir }
  let(:temp_file) { Tempfile.new('dsu', temp_folder) }
end

RSpec.configure do |config|
  config.include_context 'when dir mock and cleanup is needed'
end
