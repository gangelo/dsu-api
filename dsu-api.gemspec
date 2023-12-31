# frozen_string_literal: true

require_relative "lib/dsu/api/version"

Gem::Specification.new do |spec|
  spec.name = "dsu-api"
  spec.version = Dsu::Api::VERSION
  spec.authors      = ['Gene M. Angelo, Jr.']
  spec.email        = ['public.gma@gmail.com']

  spec.summary      = 'The dsu (Agile Daily Stand Up/DSU) api for the dsu gem (https://rubygems.org/gems/dsu).'
  spec.description  = <<-DESC
    Placeholder for the dsu (Agile Daily Stand Up/DSU) api for the dsu gem (https://rubygems.org/gems/dsu). Write your own gems that interface with the dsu gem.
  DESC
  spec.homepage = 'https://github.com/gangelo/dsu-api'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('~> 3.0')

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/gangelo/dsu-api/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport', '>= 7.0.8', '< 8.0'
  spec.add_dependency 'activemodel', '>= 7.0.8', '< 8.0'
  spec.add_dependency 'colorize', '>= 0.8.1', '< 1.0'
  spec.add_dependency 'os', '>= 1.1', '< 2.0'

  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.post_install_message = <<~POST_INSTALL
    Thank you for installing dsu-api.
  POST_INSTALL
end
