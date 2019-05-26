class User < ApplicationRecord
  # Ancrypted password
  has_secure_password

  # Model association
  has_many :decks, dependent: :destroy

  # Validation
  validates_presence_of :name, :password_confirmation

  validates :name,
    :length => { :minimum => 3, :maximum => 42 },
    :uniqueness => true

  validates :password,
    :length => { :minimum => 8, :maximum => 42 }

  validates :password,
    :format => {
      :with => /(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[&~#\-_^@=+$%?!])\S/,
      # :without => /\s/,
      :message =>
        'Password length should be between 8 and 42 characters.' +
        'Password should contain at least one lowercase.' +
        'Password should contain at least one upercase.' +
        'Password should contain at least one digit.' +
        'Password should contain at least one special character among [&~#-_^@=+$%?!].' +
        'Password should not contain whitespace character.'
    }
end
