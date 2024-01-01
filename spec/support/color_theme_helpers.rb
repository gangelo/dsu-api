# frozen_string_literal: true

# These helpers are used to create and delete the configuration file
# typically before and after every test.
module ColorThemeHelpers
  def create_color_theme!(theme_name:, theme_hash:)
    Dsu::Api::LowLevel::ColorThemeModel.new(theme_name: theme_name, theme_hash: theme_hash).save!
  end

  def create_default_color_theme!
    Dsu::Api::LowLevel::ColorThemeModel.default.save!
  end

  def delete_color_theme!(theme_name:)
    raise ArgumentError, 'theme_name is blank' if theme_name.blank?

    if Dsu::Api::LowLevel::ColorThemeModel.theme_file_exist?(theme_name: theme_name)
      Dsu::Api::LowLevel::ColorThemeModel.delete!(theme_name: theme_name)
    end
  end

  def delete_default_color_theme!
    Dsu::Api::LowLevel::ColorThemeModel.default.delete
  end
end
