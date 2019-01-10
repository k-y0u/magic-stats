require 'rails_helper'

RSpec.describe Deck, type: :model do
  # Default
  # pending "add some examples to (or delete) #{__FILE__}"

  # Association tests
  it {
    should belong_to(:user)
  }

  # Validation tests
  it {
    should validate_presence_of(:name)
  }
  it {
    should validate_presence_of(:description)
  }
end
