FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    after(:create) do |user|
      user.add_basic_deck
    end
  end
end
