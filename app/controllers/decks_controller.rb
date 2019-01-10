class DecksController < ApplicationController
  before_action :set_user
  before_action :set_user_deck, only: [:show, :update, :destroy]

  def index
    json_response(@user.decks)
  end

  def show
    json_response(@deck)
  end

  def create
    @deck = @user.decks.create!(deck_params)
    json_response(@deck, :created)
  end

  def update
    @deck.update(deck_params)
    head :no_content
  end

  def destroy
    @deck.destroy
    head :no_content
  end

  private

  def deck_params
    params.permit(:name, :description)
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_deck
    @deck = @user.decks.find_by!(id: params[:id]) if @user
  end
end
