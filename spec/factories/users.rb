FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    password { 'Pas$w0rd' }
    password_confirmation { 'Pas$w0rd' }
  end
end
