require 'rails_helper'

RSpec.describe User, type: :model do
  # Default
  # pending "add some examples to (or delete) #{__FILE__}"

  # Association tests
  it { should have_many(:decks).dependent(:destroy) }

  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:password_digest) }
end
