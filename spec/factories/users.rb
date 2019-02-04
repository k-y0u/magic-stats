FactoryBot.define do
  factory :user do
    name { Faker::FunnyName.name }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
