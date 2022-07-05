class ChangeTemplateSelectionAndColorPaletToInteger < ActiveRecord::Migration[6.0]
  def up
    execute "ALTER TABLE brand_settings ALTER template_selection DROP DEFAULT;"
    change_column :brand_settings, :template_selection, :integer, using: 'template_selection::integer', default: 0
    execute "ALTER TABLE brand_settings ALTER color_palet DROP DEFAULT;"
    change_column :brand_settings, :color_palet, :jsonb, using: 'color_palet::jsonb', default: "{}"
  end

  def down
    change_column :brand_settings, :color_palet, :string, default: "{themeName: 'Sky',primaryColor:'#364F6B',secondaryColor:'#3FC1CB'}"
    change_column :brand_settings, :template_selection, :string, default: 'Minimal'
  end
end
