FactoryBot.define do
  factory :user do
    name                    { '山田 太郎' }
    email                   { 'yamada@example.com' }
    password                { Faker::Internet.password(min_length: 6) }
    password_confirmation   { password }
  end
end