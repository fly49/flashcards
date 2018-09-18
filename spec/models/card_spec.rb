require "rails_helper"

describe Card, :type => :model do
  
  describe "scope :ready" do
    it "returns cards with today's review_date or older" do
      expect(Card.ready).to all(have_attributes(review_date: (a_value <= Date.today)))
    end
  end
  
  describe "check_translation" do
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
      card_1 = Card.create(original_text: "", translated_text: "abc")
      expect(card_1).not_to be_valid
      
      card_2 = Card.create(original_text: "abc", translated_text: "")
      expect(card_2).not_to be_valid
      
      card_3 = Card.create(original_text: "abca", translated_text: "abc")
      expect(card_3).to be_valid
    end
    
    it "validates that texts are not equal" do
      card = Card.create(original_text: "abc", translated_text: "abc")
      expect(card).not_to be_valid
      expect(card.errors.messages).to have_key :translated_text
      card = Card.create(original_text: "  aBCdEF", translated_text: "Abcdef  ")
      expect(card).not_to be_valid
      expect(card.errors.messages).to have_key :translated_text
    end
    
    it "validates texts length" do
      card_1 = Card.create(original_text: "a"*21, translated_text: "abc")
      expect(card_1).not_to be_valid
      
      card_2 = Card.create(original_text: "abc", translated_text: "b"*51)
      expect(card_2).not_to be_valid
    end
  end
  
  describe "before_create" do
    it "sets review_date to the third day after today's" do
      card = Card.new(original_text: "cde", translated_text: "abc")
      card.save
      expect(card.review_date).to eq (Date.today + 3)
    end
  end
  
  describe "self.random" do
    it "returns random record from database" do
      expect(Card.random).to be_a Card
    end
  end
end
