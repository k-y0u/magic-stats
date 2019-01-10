class User < ApplicationRecord
  # Model association
  has_many :decks, dependent: :destroy

  # Validation
  validates_presence_of :name, :password
end
