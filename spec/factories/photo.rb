FactoryBot.define do
  factory :photo do
    photo_image  { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/post_photo.jpg')) }
    caption { Faker::Lorem.characters(number: 250) }
  end
end