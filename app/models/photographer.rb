class Photographer < ApplicationRecord

  belongs_to :user
  has_many :photographer_genre_maps, foreign_key: 'photographer_id',
                                       dependent: :destroy
  has_many :genres, through: :photographer_genre_maps
  
  mount_uploader :photographer_profile_image, PhotographerProfileImageUploader
  mount_uploader :cover_image, CoverUploader
  
  # =============== ジャンル保存用の記述 ==================
  def save_photographer_genres(save_genres)
    current_genres = self.genres.pluck(:name) unless self.genres.nil?
    old_genres = current_genres - save_genres
    new_genres = save_genres - current_genres

    old_genres.each do |old_name|
      self.genres.delete Genre.find_by(name: old_name)
    end

    new_genres.each do |new_name|
      photographer_genre = Genre.find_or_create_by(name: new_name)
      self.genres << photographer_genre
    end
  end

  # =========== フォトグラファー検索用の記述 ==============
  def self.search(word)
    unless word == ""
      name = Photographer.where('name LIKE?', "%#{word}%")
      genres = Photographer.joins(:genres).where('genres.name LIKE?', "%#{word}%")
      name += genres
      photographers = name.uniq
      return photographers
    else
      Photographer.includes(:user).order(id: "DESC")
    end
  end

  validates :user_id, :name, presence: true
  validates :user_id, uniqueness: true

end
