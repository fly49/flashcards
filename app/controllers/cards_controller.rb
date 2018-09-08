class CardsController < ApplicationController
  def show
    @cards = Card.all
  end
end
