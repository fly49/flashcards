# frozen_string_literal: true

class DecksController < ApplicationController

  def index
    @decks = current_user.decks
  end
  
  def show
    @deck = current_user.decks.find(params[:id])
    @cards = @deck.cards
  end
  
  def new
    @deck = Deck.new
  end
  
  def create
    @deck = current_user.decks.build(deck_params)
    if @deck.save
      flash[:success] = I18n.t('deck.flashes.successfull.create')
      redirect_to decks_path
    else
      # Simple form automatically flashes about failing validation
      # and it need render to throw a hint
      render 'new'
    end
  end
  
  private

  def deck_params
    params.require(:deck).permit(:name, :user_id)
  end
end