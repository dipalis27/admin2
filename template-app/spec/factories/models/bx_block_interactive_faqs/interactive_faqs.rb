FactoryBot.define do
  factory :interactive_faqs, class: BxBlockInteractiveFaqs::InteractiveFaqs do
    title{Faker::Lorem.sentence}
    content{Faker::Lorem.paragraph}
  end
end