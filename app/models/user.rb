class User < ApplicationRecord
  # Ancrypted password
  has_secure_password

  # Model association
  has_many :decks, dependent: :destroy

  # Validation
  validates_presence_of :password_confirmation, :password_digest, :name

  validates :password,
    :format => { :without => /\s/, :message => 'should not contain whitespace character' },
    :length => { :minimum => 8, :maximum => 42 },
    :if => :password

  validates :name,
    :length => { :minimum => 3, :maximum => 42 },
    :uniqueness => true,
    :if => :name
end
