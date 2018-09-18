class CardsController < ApplicationController
  before_action :find_card, only: [:update, :edit, :check, :show, :destroy]
  
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
    if @card.update_attributes(card_params)
      flash[:success] = "Card updated!"
      redirect_to cards_url
    else
      render 'edit'
    end
  end
  
  def check
    if params[:check_data][:translation] == @card.original_text
      flash[:success] = "Yes!"
       @card.update_card_date
    else
      flash[:danger] = "No!"
    end
    redirect_to root_url
  end
  
  def show
  end
  
  def edit
  end
  
  def destroy
    @card.destroy
    flash[:success] = "Card deleted"
    redirect_to cards_url
  end
  
  private
  
  def card_params
    params.require(:card).permit(:original_text, :translated_text, :review_date)
  end
  
  def find_card
    @card = Card.find(params[:id])
  end
end
