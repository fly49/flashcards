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
  end
  
  def show
  end
  
  def edit
  end
  
  def destoy
  end
  
  private
  
    def card_params
      params.require(:card).permit(:original_text, :translated_text, :review_date)
    end
end
