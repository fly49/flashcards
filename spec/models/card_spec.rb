require "rails_helper"

describe Card do
  describe "scope :ready" do
    before do
      create(:card, :old)
      create(:card, :today)
      create(:card, :new)
    end
    
    it "returns cards with today's review_date or older" do
      expect(Card.ready).to all(have_attributes(review_date: (a_value <= Date.today)))
      expect(Card.ready.all.count).to eq 2
    end
  end
  
  describe "check_translation" do
    let(:card) { create(:card) }
    
    context "compare original_text with the given one" do
      it "returns truthy when translation is right" do
        expect(card.check_translation(card.original_text)).to be_truthy
      end
      
      it "returns falsey when it's wrong" do
        expect(card.check_translation("abcd")).not_to be_truthy
      end
    end
  end
  
  describe "text vaildation" do
    context "presence vaildation" do
      context "when texts are filled" do
      let(:correct_card) { create(:card) }
        it "should be valid" do
          expect(correct_card).to be_valid
        end
      end
        
      context "when original text is empty" do
        let(:card_empty_original) { build(:card, original_text: "", translated_text: "abc") }
        it "should be not valid" do
          expect(card_empty_original).not_to be_valid
        end
      end
      
      context "when translated text is empty" do
        let(:card_empty_translated) { build(:card, original_text: "abc", translated_text: "") }
        it "should not be valid" do
          expect(card_empty_translated).not_to be_valid
        end
      end
    end

    context 'when texts are equal' do 
      let(:card_same_text) { build(:card, original_text: "abc", translated_text: "abc") }
      
      it "should not be valid" do
        expect(card_same_text).not_to be_valid
      end
      it "should has an error message" do
        card_same_text.valid?
        expect(card_same_text.errors.messages).to have_key :translated_text
      end
      
      context "even it differs by case and whitespaces" do
        let(:card_camel_text) { build(:card, original_text: "  aBCdEF", translated_text: "Abcdef  ") }
        
        it "should not be valid" do
          expect(card_camel_text).not_to be_valid
        end
        
        it "should has an error message" do
          card_camel_text.valid?
          expect(card_camel_text.errors.messages).to have_key :translated_text
        end
      end
    end
    
    context "texts length validation" do
      context 'when original text is longer than 20 letters' do
        let(:card_long_original) { build(:card, original_text: "a"*21, translated_text: "b") }
        it "should not be valid" do
          expect(card_long_original).not_to be_valid
        end
      end
      
      context 'when original text is longer than 50 letters' do
        let(:card_long_translated) { build(:card, original_text: "a", translated_text: "b"*51) }
        it "should not be valid" do
          expect(card_long_translated).not_to be_valid
        end
      end
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
