class HomeController < ApplicationController
  
  def index
    unless @random_card = Card.ready.random
      @end_message = "All cards have been viewed"
    end
  end
end
