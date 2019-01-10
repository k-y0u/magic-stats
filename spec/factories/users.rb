FactoryBot.define do
  factory :user do
    name { Faker::FunnyName.name }
    password { 'password' }
  end
end
