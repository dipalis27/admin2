FactoryBot.define do
  factory :customer_feedback, class: 'BxBlockCatalogue::CustomerFeedback' do
    description{Faker::Lorem.sentence(word_count: 3)}
    customer_name{Faker::Lorem.sentence(word_count: 3)}
    position{1}
  end
end