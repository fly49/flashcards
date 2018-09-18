require "rails_helper"
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

describe Card, :type => :model do
  
  before(:each) do
    DatabaseCleaner.clean
  end
  
  describe "scope :ready" do
    before { 10.times { create(:card) } }
    
    it "returns cards with today's review_date or older" do
      expect(Card.ready).to all(have_attributes(review_date: (a_value <= Date.today)))
    end
  end
  
  describe "check_translation" do
    before { create(:card) }
    
    context "compare original_text with the given one" do
      it "returns truthy when translation is right" do
        expect(Card.find(1).check_translation(Card.find(1).original_text)).to be_truthy
      end
      
      it "returns falsey when it's wrong" do
        expect(Card.find(1).check_translation("abcd")).not_to be_truthy
      end
    end
  end
  
  describe "text vaildation" do
    it "validates presence" do
      card_1 = Card.create(original_text: "abc", translated_text: "")
      expect(card_1).not_to be_valid
      
      card_2 = Card.create(original_text: "", translated_text: "abc")
      expect(card_2).not_to be_valid
      
      card_3 = create(:card)
      expect(card_3).to be_valid
    end
    
    it "validates that texts are not equal" do
      card_1 = Card.create(original_text: "abc", translated_text: "abc")
      expect(card_1).not_to be_valid
      expect(card_1.errors.messages).to have_key :translated_text
      card_2 = Card.create(original_text: "  aBCdEF", translated_text: "Abcdef  ")
      expect(card_2).not_to be_valid
      expect(card_2.errors.messages).to have_key :translated_text
    end
    
    it "validates texts length" do
      card_1 = Card.create(original_text: "a"*21, translated_text: "b")
      expect(card_1).not_to be_valid
      
      card_2 = Card.create(original_text: "a", translated_text: "b"*51)
      expect(card_2).not_to be_valid
    end
  end
  
  describe "before_create" do
    it "sets review_date to the third day after today's" do
      card = create(:card)
      card.save
      expect(card.review_date).to eq (Date.today + 3)
    end
  end
  
  describe "self.random" do
    before { 10.times { create(:card) } }
    it "returns random record from database" do
      expect(Card.random).to be_a Card
    end
  end
end
