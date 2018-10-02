# frozen_string_literal: true

class CardsController < ApplicationController
  before_action :find_card, only: %i[update edit check show destroy]

  def index
    @cards = current_user.cards
  end

  def new
    @card = Card.new
  end

  def create
    @card = current_user.cards.build(card_params)
    if @card.save
      flash[:success] = I18n.t('card.flashes.successfull.create')
      redirect_to new_card_url
    else
      # Simple form automatically flashes about failing validation
      # and it need render to throw a hint
      render 'new'
    end
  end

  def update
    if @card.update(card_params)
      flash[:success] = I18n.t('card.flashes.successfull.update')
      redirect_to cards_url
    else
      render 'edit'
    end
  end

  def check
    if @card.check_translation(params[:check_data][:translation])
      flash[:success] = I18n.t('card.flashes.successfull.check')
    else
      flash[:danger] = I18n.t('card.flashes.unsuccessfull.check')
    end
    redirect_to root_url
  end

  def show; end

  def edit; end

  def destroy
    @card.destroy
    flash[:success] = I18n.t('card.flashes.successfull.destroy')
    redirect_to cards_url
  end

  private

  def card_params
    params.require(:card).permit(:original_text, :transcription, :translated_text,
                                 :review_date, :image, :remove_image, deck_ids:[])
  end

  def find_card
    @card = current_user.cards.find(params[:id])
  end
end
