module BxBlockWishlist
  class Wishlist < BxBlockWishlist::ApplicationRecord
    self.table_name = :wishlists

    has_many :wishlist_items, class_name: "BxBlockWishlist::WishlistItem", dependent: :destroy
    has_many :catalogues, through: :wishlist_items, class_name: "BxBlockCatalogue::Catalogue"
    belongs_to :account, class_name: "AccountBlock::Account"
  end
end