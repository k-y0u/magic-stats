class JsonWebToken
  # Secret encode & decode token
  HMAC_SECRET = Rails.application.secrets.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    # Set expiry to 24 hours from creation time
    payload[:exp] = exp.to_i
    # Sign token with application secret
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(token)
    # Get payload; First index in decoded array
    body = JWT.decode(token, HMAC_SECRET)[0]
    HashWithIndifferentAccess.new body

    # Rescue from all decode errors
  rescue JWT::DecodeError => e
    # Raise a custom error to be handled by custom handler
    raise ExceptionHandler::InvalidToken, e.message
  end
end
