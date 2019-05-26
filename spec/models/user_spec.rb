require 'rails_helper'

RSpec.describe User, type: :model do

  # Association tests
  it { should have_many(:decks).dependent(:destroy) }

  # Validation Presence Of
  it { should validate_presence_of(:name) }
  it { should have_secure_password }
  it { should validate_presence_of(:password_confirmation) }

  # Validation Name Format
  it { should validate_length_of(:name).is_at_least(3).is_at_most(42) }
  it { should validate_uniqueness_of(:name) }

  # Validation Password Format
  it { should validate_length_of(:password).is_at_least(8).is_at_most(42) }
  # No content validation existing with Shoulda

end
