require 'rails_helper'

RSpec.describe Deck, type: :model do
  # Association tests
  it { should belong_to(:user) }

  # Validation tests
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }

  # Validation Name Format
  it { should validate_length_of(:name).is_at_least(3).is_at_most(42) }
  it { should validate_uniqueness_of(:name) }

end
