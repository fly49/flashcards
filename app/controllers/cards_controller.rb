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
      flash[:success] = "Card has been succesfully added!"
      redirect_to new_card_url
    else
      # Simple form automatically flashes about failing validation
      # and it need render to throw a hint
      render 'new'
    end
  end
  
  def update
    @card = Card.find(params[:id])
    if @card.update_attributes(card_params)
      flash[:success] = "Card updated!"
      redirect_to cards_url
    else
      render 'edit'
    end
  end
  
  def show
  end
  
  def edit
    @card = Card.find(params[:id])
  end
  
  def destroy
    Card.find(params[:id]).destroy
    flash[:success] = "Card deleted"
    redirect_to cards_url
  end
  
  private
  
    def card_params
      params.require(:card).permit(:original_text, :translated_text, :review_date)
    end
end
