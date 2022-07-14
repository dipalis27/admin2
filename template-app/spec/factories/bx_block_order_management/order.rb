FactoryBot.define do
  factory :order, class: "BxBlockOrderManagement::Order" do
    order_date {Time.now}
    after(:build) do |order|
      account = FactoryBot.create(:customer)
      catalogue = FactoryBot.create(:catalogue)
      order.account = account
      order.order_items.new(catalogue_id: catalogue.id, quantity: 1)
    end
  end
end
