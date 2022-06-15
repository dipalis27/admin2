# This migration comes from bx_block_store_profile (originally 20220419104625)
class AddTemplateSelectionToBrandSettings < ActiveRecord::Migration[6.0]
  def change
    add_column :brand_settings, :template_selection, :integer, default:0
    add_column :brand_settings, :color_palet, :integer, default:0
  end
end
