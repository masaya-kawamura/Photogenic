FactoryBot.define do
  factory :rate do
    rate     { 3 }
    comment  { Faker::Lorem.characters(number: 400) }
  end
end
