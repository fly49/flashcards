FactoryBot.define do
  factory :card do
    original_text { random_text }
    translated_text { random_text }
    user_id { nil }
    deck_ids { [User.find(user_id).current_deck.id] }

    trait :old do
      after(:create) do |instance|
        instance.update_attribute(:review_date, Date.today - 1)
      end
    end

    trait :today do
      after(:create) do |instance|
        instance.update_attribute(:review_date, Date.today)
      end
    end

    trait :new do
      after(:create) do |instance|
        instance.update_attribute(:review_date, Date.today + 1)
      end
    end
  end
end
