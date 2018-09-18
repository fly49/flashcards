class HomeController < ApplicationController
  
  def index
    @random_card = Card.ready.random
  end
end
