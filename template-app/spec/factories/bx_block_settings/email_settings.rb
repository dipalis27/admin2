FactoryBot.define do
  factory :email_setting, class: "BxBlockSettings::EmailSetting" do
    sequence(:title) { |times| "EMAIL-TITLE-#{Time.now.to_i}" }
    content { Faker::Lorem.sentence }
    event_name { [0, 1, 2].sample }
    active { Faker::Boolean.boolean }
  end
end