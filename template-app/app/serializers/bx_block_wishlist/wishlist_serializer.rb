module BxBlockWishlist
  class WishlistSerializer < BuilderBase::BaseSerializer
    attribute :wishlist_items do |wishlist, params|
      wishlist.wishlist_items.collect do |wishlist_item|
        WishlistItemSerializer.new(wishlist_item, { params: params })
      end
    end
  end
end
