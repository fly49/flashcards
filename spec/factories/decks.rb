FactoryBot.define do
  factory :deck do
    name { Faker::Internet.slug }
    user_id { nil }
  end
end