# frozen_string_literal: true

class DecksController < ApplicationController

  def index
    @decks = current_user.decks
  end
  
  def show
    @cards = current_user.decks.find(params[:id]).cards
  end
end