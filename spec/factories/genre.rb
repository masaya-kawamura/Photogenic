FactoryBot.define do
  factory :genre do
    name  { Faker::Lorem.characters(number: 6) }
  end
end