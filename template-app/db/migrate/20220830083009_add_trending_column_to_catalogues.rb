class AddTrendingColumnToCatalogues < ActiveRecord::Migration[6.0]
  def change
    add_column :catalogues, :trending, :boolean, default: false
  end
end
