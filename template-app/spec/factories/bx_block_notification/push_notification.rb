FactoryBot.define do
  factory :push_notification, class: "BxBlockNotification::PushNotification" do
    title{Faker::Lorem.word}
    message{Faker::Lorem.sentence}
  end
end