class UsersController < ApplicationController
  def index
    render :json => User.all
  end

  def create
    @user = User.new(params[:user])
    @user.save
    render :json => @user
  end

  def show
    render :json => User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(params[:user])
    render :json => @user
  end

  def destroy
    @user = User.find(params[:id])
    render :json => @user.destroy
  end
end
