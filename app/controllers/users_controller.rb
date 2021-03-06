class UsersController < ApplicationController
  skip_before_action :authorize_request, only: :create

  # GET /users
  def index
    @users = User.all
    json_response(@users)
  end

  # POST /users
  def create
    @user = User.create!(user_params)
    @auth_token = AuthenticateUser.new(@user.name, @user.password).call
    @response = { message: Message.account_created, auth_token: @auth_token, user: @user }
    json_response(@response, :created)
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
    json_response(@user)
  end

  # PUT /users/:id
  def update
    if params[:id] == (current_user.id.to_s)
      current_user.update(user_params)
      head :no_content
    else
      raise(
        ExceptionHandler::InvalidUser,
        Message.invalid_user
      )
    end
  end

  # DELETE /users/:id
  def destroy
    if params[:id] == (current_user.id.to_s)
      current_user.destroy
      head :no_content
    else
      raise(
        ExceptionHandler::InvalidUser,
        Message.invalid_user
      )
    end
  end

  private

  def user_params
    # whitelist params
    params.permit(:name, :password, :password_confirmation)
  end
end
