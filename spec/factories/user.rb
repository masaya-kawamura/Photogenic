FactoryBot.define do
  factory :user, aliases:[:owner] do
    name                    { '山田 太郎' }
    sequence(:email)        { |n| "yamada#{n}@example.com" }
    password                { Faker::Internet.password(min_length: 6) }
    password_confirmation   { password }
  end
end