class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :photo

  validates :user_id, :photo_id, presence: true
  validates_uniqueness_of :photo_id, scope: :user_id

end
