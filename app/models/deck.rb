class Deck < ApplicationRecord
  # Model association
  belongs_to :user

  # Validation
  validates_presence_of :name, :description
end
