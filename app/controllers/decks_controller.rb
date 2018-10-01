# frozen_string_literal: true

class DecksController < ApplicationController
  before_action :find_deck, only: %i[show update edit make_current destroy]

  def index
    @decks = current_user.decks
  end
  
  def show
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
      render 'new'
    end
  end
  
  def update
    if @deck.update(deck_params)
      flash[:success] = I18n.t('deck.flashes.successfull.update')
      redirect_to decks_path
    else
      render 'edit'
    end
  end
  
  def destroy
    return if @deck.current?
    @deck.destroy
    flash[:success] = I18n.t('deck.flashes.successfull.destroy')
    redirect_to decks_path
  end
  
  def make_current
    current_user.update(current_deck: @deck)
    redirect_to decks_path
  end
  
  def edit; end
  
  private
  
  def find_deck
    @deck = current_user.decks.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_back_or_to root_path
  end

  def deck_params
    params.require(:deck).permit(:name, :user_id)
  end
end