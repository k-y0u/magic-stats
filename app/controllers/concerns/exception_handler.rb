module ExceptionHandler
  extend ActiveSupport::Concern

  # Define custom error subclasses - rescue catches 'StandardErrors'
  class AuthenticationError < StandardError; end
  class MissingToken < StandardError; end
  class InvalidToken < StandardError; end

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :four_zero_four
    rescue_from ActiveRecord::RecordInvalid, with: :four_twenty_two

    # Define custom handlers
    rescue_from ExceptionHandler::AuthenticationError, with: :four_zero_one
    rescue_from ExceptionHandler::MissingToken, with: :four_twenty_two
    rescue_from ExceptionHandler::InvalidToken, with: :four_twenty_two
  end

  private

  # JSON response with message; Status code 401 - unauthorized
  def four_zero_one(e)
    json_response({ message: e.message }, :unauthorized)
  end

  # JSON response with message; Status code 404 - not found
  def four_zero_four(e)
    json_response({ message: e.message }, :not_found)
  end

  # JSON response with message; Status code 422 - unprocessable entity
  def four_twenty_two(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end
end
