# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :require_login, only: [:index]

  def index
    return unless current_user

    @user = User.find(current_user.id)
    @random_card = @user.card_for_check
  end
end
