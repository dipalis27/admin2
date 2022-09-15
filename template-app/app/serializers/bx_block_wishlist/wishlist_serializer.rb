module BxBlockWishlist
  class WishlistSerializer < BuilderBase::BaseSerializer
    attribute :wishlist_items do |wishlist, params|
      wishlist.wishlist_items.joins(:catalogue).where(catalogues: {status: 'active'}).page(params[:page]).per(params[:per_page]).collect do |wishlist_item|
        WishlistItemSerializer.new(wishlist_item, { params: params })
      end
    end

    attribute :wishlist_count do |wishlist|
      return 0 if !wishlist.present?
      wishlist.wishlist_items.joins(:catalogue).where(catalogues: {status: 'active'}).count
    end
  end
end
