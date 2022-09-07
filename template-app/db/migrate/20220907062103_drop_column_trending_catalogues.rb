class DropColumnTrendingCatalogues < ActiveRecord::Migration[6.0]
  def change
    remove_column :catalogues, :trending
  end
end
