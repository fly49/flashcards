require "rails_helper"

describe Card do
  describe "scope :ready" do
    before do
      create(:card).update_attribute(:review_date, Date.today - 1)
      create(:card).update_attribute(:review_date, Date.today)
      create(:card).update_attribute(:review_date, Date.today + 1)
    end
    
    it "returns cards with today's review_date or older" do
      expect(Card.ready).to all(have_attributes(review_date: (a_value <= Date.today)))
      expect(Card.ready.all.count).to eq 2
    end
  end
  
  describe "check_translation" do
    before { create(:card) }
    
    context "compare original_text with the given one" do
      it "returns truthy when translation is right" do
        expect(Card.first.check_translation(Card.first.original_text)).to be_truthy
      end
      
      it "returns falsey when it's wrong" do
        expect(Card.first.check_translation("abcd")).not_to be_truthy
      end
    end
  end
  
  describe "text vaildation" do
    let(:card) { create(:card) }
    it "validates presence" do
      expect(card).to be_valid
      
      card.update(original_text: "abc", translated_text: "")
      expect(card).not_to be_valid
      
      card.update(original_text: "", translated_text: "abc")
      expect(card).not_to be_valid
    end

    context 'when texts are equal' do 
      card.update(original_text: "abc", translated_text: "abc")
      it "should not be valid" do
        expect(card).not_to be_valid
      end
      it "should has an error message" do
        expect(card.errors.messages).to have_key :translated_text
      end
      
      card.update(original_text: "  aBCdEF", translated_text: "Abcdef  ")
      it "should not be valid" do
        expect(card).not_to be_valid
      end
      it "should has an error message" do
        expect(card.errors.messages).to have_key :translated_text
      end
    end
    
    it "validates texts length" do
      card.update(original_text: "a"*21, translated_text: "b")
      expect(card).not_to be_valid
      
      card.update(original_text: "a", translated_text: "b"*51)
      expect(card).not_to be_valid
    end
  end
  
  describe "before_create" do
    let(:card) { create(:card) }
    it "sets review_date to the third day after today's" do
      expect(card.review_date).to eq (Date.today + 3)
    end
  end
  
  describe "self.random" do
    before { create(:card) }
    it "returns random record from database" do
      expect(Card.random).to be_a Card
    end
  end
end
