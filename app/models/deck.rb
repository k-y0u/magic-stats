class Deck < ApplicationRecord
  # Model association
  belongs_to :user

  # Validation
  validates_presence_of :name, :description

  validates :name,
    :length => { :minimum => 3, :maximum => 42 },
    :uniqueness => true
end
