class Genre < ApplicationRecord
  validates :name, uniqueness: true
  validates :name, presence: true

  has_many :photographer_genre_maps, foreign_key: 'genre_id',
                                     dependent: :destroy
  has_many :photographers, through: :photographer_genre_maps
  has_many :photo_genre_maps, foreign_key: 'genre_id',
                              dependent: :destroy
  has_many :photos, through: :photo_genre_maps
end
