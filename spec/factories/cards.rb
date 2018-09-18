FactoryBot.define do 
  factory :card do 
    original_text { random_text }
    translated_text { random_text }
    review_date { Date.today + rand(-10..10) }
  end
end

def random_text
  ('a'..'t').to_a.shuffle.join
end