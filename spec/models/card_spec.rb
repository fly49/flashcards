# frozen_string_literal: true

require 'rails_helper'

describe Card do
  it { should belong_to(:user) }

  let(:user) { create(:user, password: 'abcdef') }

  describe 'scope :ready' do
    let!(:old_card)   { create(:card, :old, user: user) }
    let!(:today_card) { create(:card, :today, user: user) }
    let!(:new_card)   { create(:card, :new, user: user) }

    it "returns cards with today's review_date or older" do
      expect(Card.ready).to all(have_attributes(review_date: (a_value <= Date.today)))
      expect(Card.ready.all).to eq [old_card, today_card]
    end
  end

  describe 'check_translation' do
    let(:card) { create(:card, original_text: 'original', user: user) }

    context 'compare original_text with the given one' do
      context 'set check_distance to 0 if translation is absolutely right' do
        before { card.check_translation(card.original_text) }
        it { expect(card.check_distance).to eq 0 }
      end
      
      context "check_distance is less or equals 2 if translation is almost right" do
        before { card.check_translation('oregenal') }
        it { expect(card.check_distance).to be <= 2 }
      end

      context "check_distance is more than 2 if translation is wrong" do
        before { card.check_translation('abcd') }
        it { expect(card.check_distance).to be > 2 }
      end
    end

    context 'interval checking' do
      it 'first successfull check increases review date by one day' do
        expect { card.check_translation(card.original_text) }.to change { card.review_date }.to Date.today + 1
      end

      it 'second successfull check increases review date by 3 days' do
        expect { 2.times { card.check_translation(card.original_text) } }.to change { card.review_date }.to Date.today + 3
      end

      it 'third successfull check increases review date by 7 days' do
        expect { 3.times { card.check_translation(card.original_text) } }.to change { card.review_date }.to Date.today + 7
      end

      it 'fourth successfull check increases review date by 14 days' do
        expect { 4.times { card.check_translation(card.original_text) } }.to change { card.review_date }.to Date.today + 14
      end

      it 'fifth successfull check increases review date by 28 days' do
        expect { 5.times { card.check_translation(card.original_text) } }.to change { card.review_date }.to Date.today + 28
      end

      context 'rollback when to much fails' do
        before { 3.times { card.check_translation(card.original_text) } }

        it '3 failed checks in a row rollback review date to one day' do
          expect { 3.times { card.check_translation('abcd') } }.to change { card.review_date }.to Date.today + 1
        end
      end
    end
  end

  describe 'text vaildation' do
    context 'presence vaildation' do
      context 'when texts are filled' do
        let(:correct_card) { create(:card, user: user) }
        it 'should be valid' do
          expect(correct_card).to be_valid
        end
      end

      context 'when original text is empty' do
        let(:card_empty_original) { build(:card, original_text: '', translated_text: 'abc', user: user) }
        it 'should be not valid' do
          expect(card_empty_original).not_to be_valid
        end
      end

      context 'when translated text is empty' do
        let(:card_empty_translated) { build(:card, original_text: 'abc', translated_text: '', user: user) }
        it 'should not be valid' do
          expect(card_empty_translated).not_to be_valid
        end
      end
    end

    context 'when texts are equal' do
      let(:card_same_text) { build(:card, original_text: 'abc', translated_text: 'abc', user: user) }

      it 'should not be valid' do
        expect(card_same_text).not_to be_valid
      end
      it 'should has an error message' do
        card_same_text.valid?
        expect(card_same_text.errors.messages).to have_key :translated_text
      end

      context 'even it differs by case and whitespaces' do
        let(:card_camel_text) { build(:card, original_text: '  aBCdEF', translated_text: 'Abcdef  ', user: user) }

        it 'should not be valid' do
          expect(card_camel_text).not_to be_valid
        end

        it 'should has an error message' do
          card_camel_text.valid?
          expect(card_camel_text.errors.messages).to have_key :translated_text
        end
      end
    end

    context 'texts length validation' do
      context 'when original text is longer than 20 letters' do
        let(:card_long_original) { build(:card, original_text: 'a' * 21, translated_text: 'b', user: user) }
        it 'should not be valid' do
          expect(card_long_original).not_to be_valid
        end
      end

      context 'when original text is longer than 50 letters' do
        let(:card_long_translated) { build(:card, original_text: 'a', translated_text: 'b' * 51, user: user) }
        it 'should not be valid' do
          expect(card_long_translated).not_to be_valid
        end
      end
    end
  end

  describe 'before_create' do
    let(:card) { create(:card, user: user) }
    it "sets review_date to the third day after today's" do
      expect(card.review_date).to eq(Date.today)
    end
  end

  describe 'self.random' do
    before { create(:card, user: user) }
    it 'returns random record from database' do
      expect(Card.random).to be_a Card
    end
  end
end
