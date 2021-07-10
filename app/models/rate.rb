class Rate < ApplicationRecord

  belongs_to :photo
  belongs_to :user

  validates :user_id, :photo_id, :rate, presence: true

end
