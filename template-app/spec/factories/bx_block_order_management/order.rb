FactoryBot.define do
  factory :order, class: "BxBlockOrderManagement::Order" do
    order_date {Time.now}
    association :account, :factory => :customer
    after(:create) do |order|
      catalogue = FactoryBot.create(:catalogue)
      order.order_items.create(catalogue_id: catalogue.id, quantity: 1)
    end
  end
end
