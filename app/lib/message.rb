class Message
  def self.not_found(record = 'record')
    "Sorry, #{record} not found."
  end

  def self.invalid_credentials
    'Invalid credentials'
  end

  def self.invalid_token
    'Invalid token'
  end

  def self.missing_token
    'Missing token'
  end

  def self.account_created
    'Account created successfully'
  end

  def self.invalid_user
    'Invalid user account. It\'s only possible to modify your own account'
  end
end
