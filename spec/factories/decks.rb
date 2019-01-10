FactoryBot.define do
  factory :deck do
    name { Faker::Pokemon.move }
    description { Faker::Movie.quote }
    user { nil }
  end
end
