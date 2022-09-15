class AddMetaFieldsToCatalogue < ActiveRecord::Migration[6.0]
  def change
    add_column :catalogues, :meta_title, :string
    add_column :catalogues, :meta_description, :text
  end
end
