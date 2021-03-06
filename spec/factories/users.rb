FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    settings { {'locale': 'en'} }
    after(:create) do |user|
      user.add_basic_deck
    end
  end
end
