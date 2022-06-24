FactoryBot.define do 
  factory :catalogue, class: "BxBlockCatalogue::Catalogue" do
    brand_id {  }
    name { Faker::Commerce.product_name }
    sequence(:sku) { |num| "PRODUCT_#{num}" }       # uniq.
    description { Faker::Commerce.department }
    manufacture_date {}                             # should be < today's date
    length {}
    breadth {}
    height {}
    availability {}
    stock_qty { Faker::Number.number(digits: 3) }
    weight { 5 }                                    # should be >= zero and <= 10. 
    price { Faker::Commerce.price }
    recommended {}
    on_sale {}                                      
    sale_price {}                                   # If on_sale is true, then sale_price should be present and should be <= price.
    discount {}
    block_qty {}
    sold {}
    available_price {}
    status { 0 }
    tax_amount {}
    price_including_tax {}
    tax                                             # tax is manditory, if status is active.
  end
end
