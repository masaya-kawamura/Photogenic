FactoryBot.define do
  factory :photographer do
    name           { '山田 太郎' }
    introduction   { Faker::Lorem.characters(number:200) }
    instagram_url  { Faker::Internet.url }
    facebook_url   { Faker::Internet.url }
    area           { Faker::Lorem.characters(number: 10) }
    photographer_profile_image { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/user_profile.jpg')) }
    cover_image                { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/cover.jpg')) }
  end
end