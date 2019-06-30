class Card < ApplicationRecord
  validates_presence_of :name,
    :cost,
    :type,
    :kind,
    :rarity,
    on: :create

  validates_uniqueness_of :name
end
