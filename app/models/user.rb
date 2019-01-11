class User < ApplicationRecord
  # Ancrypted password
  has_secure_password

  # Model association
  has_many :decks, dependent: :destroy

  # Validation
  validates_presence_of :name, :password_digest
end
