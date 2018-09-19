FactoryBot.define do 
  factory :card do 
    original_text { random_text }
    translated_text { random_text }
    #review_date { Date.today + rand(-10..10) }
    #after(:build) { |user| user.class.skip_callback(:create, :before) }
  end
end
