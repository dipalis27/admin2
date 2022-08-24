module BxBlockFilterItems
  class FilteringController < ApplicationController
    def index
      if params[:q].nil?
        @catalogues = BxBlockCatalogue::Catalogue.active
      else
        @catalogues = CatalogueFilter.new(::BxBlockCatalogue::Catalogue, params[:q]).call
        save_recent_search
      end

      # To keep order by consistent for frontend
      if params[:sort] && params[:sort][:order_by] == "recommended"
        params[:sort][:order_field] = "recommended"
        params[:sort].delete :order_by
      end

      render(json: { message: "No product found" }, status: 200) && return if @catalogues.empty?

      @catalogues = BxBlockSorting::SortRecords.new(
        @catalogues, params[:sort]
      ).call if params[:sort].present?

      if params[:sort].present? && params[:sort][:order_field] == "recommended"
        @catalogues = @catalogues.recommended
      end

      if params[:discounted_items].present?
        @catalogues = @catalogues.discounted_items
      end

      catalogue_count = @catalogues.count
      page_no = params[:page].to_i == 0 ? 1 : params[:page].to_i
      per_page = params[:per_page].to_i == 0 ? 10 : params[:per_page].to_i

      @catalogues = @catalogues.page(page_no).per(per_page)

      data = BxBlockCatalogue::CatalogueSerializer.new(@catalogues, serialization_options).serializable_hash
      data[:meta] = { pagination: {
        current_page: @catalogues.current_page,
        next_page: @catalogues.next_page,
        prev_page: @catalogues.prev_page,
        total_pages: @catalogues.total_pages,
        total_count: catalogue_count
      }
      }

      render json: data, status: :ok
    end

    private

    def serialization_options
      { params: { host: request.protocol + request.host_with_port, user: @current_user, ignore_similar_nesting: true } }
    end

    def save_recent_search
      return unless params[:q][:name]

      if params[:q][:id]
        id = params[:q][:id].first
        type = "Catalogue"
      elsif params[:q][:sub_category_id]
        id = params[:q][:sub_category_id].first
        type = "SubCategory"
      elsif params[:q][:category_id]
        id = params[:q][:category_id].first
        type = "Category"
      end

      # unless (BxBlockSearch::RecentSearch.all.pluck(:search_term).include? params[:q][:name]) &&
      # (BxBlockSearch::RecentSearch.all.pluck(:user_id).include? @current_user.id)
      BxBlockSearch::RecentSearch.create!(
        search_term: params[:q][:name],
        user_id: @current_user.id,
        search_id: id.to_i,
        search_type: type
      )
      # end
    end
  end
end
