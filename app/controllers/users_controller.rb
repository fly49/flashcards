# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if RegisterUserService.register_user(@user, proper_locale)
      auto_login(@user)
      flash[:success] = I18n.t('user.flashes.successfull.create')
      redirect_to root_path
    else
      render 'new'
    end
  end

  def update
    find_user
    if @user.update_attributes(user_params)
      flash[:success] = I18n.t('user.flashes.successfull.update')
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :settings => ['locale'])
  end

  def find_user
    @user = User.find(params[:id])
  end
end
