class CardsController < ApplicationController
  
  def index
    @cards = Card.all
  end
  
  def new
    @card = Card.new
  end
  
  def create
    @card = Card.new(card_params)
    if @card.save
      flash.now[:success] = "Card has been succesfully added!"
      new
    else
      flash.now[:danger] = "Original text and translated text should not be equal!"
    end
    render 'new'
  end
  
  def update
    @card = Card.find(params[:id])
    if @card.update_attributes(card_params)
      flash.now[:success] = "Card updated!"
      index
      render 'index'
    else
      render 'edit'
    end
  end
  
  def show
  end
  
  def edit
    @card = Card.find(params[:id])
  end
  
  def destoy
  end
  
  private
  
    def card_params
      params.require(:card).permit(:original_text, :translated_text, :review_date)
    end
end
