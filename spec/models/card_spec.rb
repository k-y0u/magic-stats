require 'rails_helper'

RSpec.describe Card, type: :model do
  describe 'Validation' do
    it {
      should validate_presence_of(:name).on(:create)
      should validate_uniqueness_of(:name)
    }
    it { should validate_presence_of(:cost).on(:create) }
    it { should validate_presence_of(:type).on(:create) }
    it { should validate_presence_of(:kind).on(:create) }
    it { should validate_presence_of(:rarity).on(:create) }
  end
end
