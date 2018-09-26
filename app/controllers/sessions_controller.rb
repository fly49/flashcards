# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_login, except: [:destroy]

  def new; end

  def index
    render 'home/index'
  end

  def create
    if login(params[:session][:email], params[:session][:password], params[:session][:remember_me])
      flash[:success] = I18n.t('session.flashes.successfull.create')
      redirect_back_or_to root_path
    else
      flash.now[:danger] = I18n.t('session.flashes.unsuccessfull.create')
      render 'home/index'
    end
  end

  def destroy
    logout
    redirect_to root_url
  end
end
