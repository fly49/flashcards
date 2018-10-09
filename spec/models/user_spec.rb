# frozen_string_literal: true

require 'rails_helper'

describe User do
  it { should have_many(:cards) }
  
  context 'sending emails' do
    let(:user) { create(:user) }
    ActiveJob::Base.queue_adapter = :test
    
    it 'should send welcome email' do
      expect { user.send_welcome_email }
        .to have_enqueued_job.on_queue('default')
    end
    
    before do
      create(:card, :old, user: user)
    end
    it 'should notify about expired cards' do
      expect { User.notify_cards }
        .to have_enqueued_job.on_queue('default')
    end
  end

  describe 'text vaildation' do
    let(:user) { create(:user) }

    it { should validate_presence_of(:email) }
    it 'should validate that :email is unique' do
      expect(user).to validate_uniqueness_of(:email).ignoring_case_sensitivity
    end
    it { should validate_length_of(:email).is_at_most(100) }
    it { should validate_length_of(:password).is_at_least(6) }

    context 'when email is typed incorrectrly' do
      let(:users_invalid_email) do
        %w[ user@foo,com user_at_foo.org example.user@foo.
            foo@bar_baz.com foo@bar+baz.com ]
          .map do |adr|
          build(:user, email: adr)
        end
      end

      it 'should be not valid' do
        users_invalid_email.each do |user|
          expect(user).not_to be_valid
        end
      end
    end

    context 'when email is typed correctrly' do
      let(:user_downcase_email) { build(:user, email: 'foo@bar.com') }
      let(:user_uppercase_email) { build(:user, email: 'FOO@BAR.COM') }

      it 'should be valid' do
        expect(user_downcase_email).to be_valid
        expect(user_uppercase_email).to be_valid
      end
    end
  end

  context 'email addresses should be saved as lower-case' do
    let(:mixed_case_email) { 'Foo@ExAMPle.CoM' }
    let(:user) { create(:user, email: mixed_case_email) }
    it 'should store email in lower-case' do
      expect(user.email).to eq mixed_case_email.downcase
    end
  end
end
