# frozen_string_literal: true

class HomeController < ApplicationController
  skip_before_action :require_login, only: [:index]

  def index
    if current_user
      @user = User.find(current_user.id)
      @end_message = 'All cards have been viewed' unless @random_card = @user.cards.ready.random
    end
  end
end
