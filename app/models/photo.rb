class Photo < ApplicationRecord

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :photo_genre_maps, foreign_key: 'photo_id',
                                dependent: :destroy
  has_many :genres, through: :photo_genre_maps

  mount_uploader :photo_image, PhotoUploader

  validates :photo_image, presence: true

  # =========== もういいねしてる? ============
  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # ========= ジャンル保存メソッド ===========
  def save_photos(save_genres)
    current_genres = self.genres.pluck(:name) unless self.genres.nil?
    old_genres = current_genres - save_genres
    new_genres = save_genres - current_genres

    old_genres.each do |old_name|
      self.genres.delete Genre.find_by(name: old_name)
    end

    new_genres.each do |new_name|
      photo_genre = Genre.find_or_create_by(name: new_name)
      self.genres << photo_genre
    end
  end

end
