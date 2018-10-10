# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_login
  before_action :set_locale
  
  private

  def set_locale
    locale = proper_locale
    p locale
    p I18n.available_locales.include?(locale.to_sym)
    session[:locale] = I18n.locale = locale.to_sym if locale && I18n.available_locales.include?(locale.to_sym)
  end

  def proper_locale
    if current_user
      p "hello current_user #{current_user.settings['locale']}"
      current_user.settings['locale']
    elsif params[:locale]
      p "hello params #{params[:locale]}"
      session[:locale] = params[:locale]
    elsif session[:locale]
      p "hello session #{session[:locale]}"
      session[:locale]
    else
      p "hello http #{http_accept_language.compatible_language_from(I18n.available_locales)}"
      http_accept_language.compatible_language_from(I18n.available_locales)
    end
  end

  def not_authenticated
    redirect_to login_path, danger: I18n.t('app_controller.not_authenticated')
  end
end
