module BxBlockWishlist
  class WishlistItem < BxBlockWishlist::ApplicationRecord
    self.table_name = :wishlist_items

    belongs_to :wishlist, class_name: "BxBlockWishlist::Wishlist"
    belongs_to :catalogue, class_name: "BxBlockCatalogue::Catalogue"
    belongs_to :catalogue_variant, class_name: "BxBlockCatalogue::CatalogueVariant", optional: true
  end
end
