class PhotographerGenreMap < ApplicationRecord

  belongs_to :photographer
  belongs_to :genre

  validates :photographer_id, :genre_id, presence: true

end
