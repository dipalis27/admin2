module BxBlockFilterItems
  class ApplicationFilter
    attr_accessor :active_record, :query_params, :date_format

    # Sample query_params:
    # {
    #   "price": {"from": 100, "to": 500},
    #   "category_id": 1,
    #   "brand_id": [1, 2],
    # }
    def initialize(active_record, query_params)
      if active_record == BxBlockCatalogue::Catalogue
        @active_record = active_record.active
      else
        @active_record = active_record
      end
      @query_params = query_params || {}
      @query_params = @query_params.permit!.to_h.deep_symbolize_keys if !@query_params.is_a?(Hash)
    end

    def call
      query_params.present? ? active_record.where(query_string) : []
    end

    private

    def query_string
      query_str = ""
      query_params.each_with_index do |(key, value), index|
        query_str += query_string_for(key, value)
        query_str += " AND " if index < query_params.length - 1
      end

      query_str
    end

    def query_string_for(attr_name, value)
      raise "Must be implemented in derived class"
    end
  end
end
