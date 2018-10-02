FactoryBot.define do
  factory :deck do
    name { Faker::Internet.slug }
    user
  end
end