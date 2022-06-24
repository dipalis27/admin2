FactoryBot.define do
  factory :help_center, class: BxBlockHelpCenter::HelpCenter do
    title{Faker::Lorem.sentence}
    description{Faker::Lorem.sentence}
    help_center_type{"other"}
  end
end