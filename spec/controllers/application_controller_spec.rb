require 'rails_helper'
RSpec.configure do |c|
  c.infer_base_class_for_anonymous_controllers = false
end


class DummyController < ApplicationController; end

describe DummyController, :type => :controller do
  controller DummyController do
    def index
      p 'hello'
      head :ok
    end
  end

  context 'when user logged in' do
    before do 
      #user = create(:user, settings: {'locale': 'ru'})
      #login_user(user)
      get :index
    end
    it 'set locale as in user settings' do
      expect(I18n.locale).to eq :ru
    end
  end
  
  context 'when locale specified in params' do
    it 'set locale as in setted in params' do
      #controller.params[:locale] = 'ru'
      get :index
      expect(I18n.locale).to eq :en
    end
  end
  
  context 'when locale specified in params' do
    it 'set locale as in setted in params' do
      #controller.session[:locale] = 'ru'
      get :index
      expect(I18n.locale).to eq :ru
    end
  end
end
