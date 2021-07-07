class Photo < ApplicationRecord

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  mount_uploader :photo_image, PhotoUploader

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

end
