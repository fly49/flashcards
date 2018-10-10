require 'rails_helper'

describe ApplicationController do
  controller do
    skip_before_action :require_login
    def dummy
      head :ok
    end
  end
  
  before(:each) do
    routes.draw { get "dummy" => "anonymous#dummy" }
    request.env['HTTP_ACCEPT_LANGUAGE'] = "en"
  end

  context 'when user logged in' do
    before do 
      user = create(:user, settings: {'locale': 'ru'})
      login_user(user)
    end
    it 'set locale as in user settings' do
      get :dummy
      expect(I18n.locale).to eq :ru
    end
  end
  
  context 'when locale is specified in params' do
    it 'set locale as it is setted in params' do
      get :dummy, params: { locale: 'ru' }
      expect(I18n.locale).to eq :ru
    end
  end
  
  context 'when locale is specified in params' do
    it 'set locale as it is setted in session' do
      controller.session[:locale] = 'ru'
      get :dummy
      expect(I18n.locale).to eq :ru
    end
  end
  
  context 'when locale is not specified anywhere' do
    it 'set locale from HTTP_ACCEPT_LANGUAGE' do
      get :dummy
      expect(I18n.locale).to eq :en
    end
  end
end
