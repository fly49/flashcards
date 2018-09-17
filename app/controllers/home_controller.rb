class HomeController < ApplicationController
  
  def index
    #@random_card = Card.outdated.random
    @random_card = Card.random
  end
  
  def check
    card = Card.find(params[:card_id])
    if params[:translation] == card.original_text
      flash[:success] = "Yes!"
      update_card_date
    else
      flash[:danger] = "No!"
    end
    redirect_to root_url
  end
  
  private
  
  def update_card_date
    Card.find(params[:card_id]).set_review_date
  end
end
