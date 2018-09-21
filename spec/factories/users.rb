FactoryBot.define do
  factory :user do
    email { "#{random_text}@#{random_text}.com" }
    password { random_text }
  end
end
