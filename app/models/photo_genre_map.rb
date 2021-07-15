class PhotoGenreMap < ApplicationRecord

  belongs_to :photo
  belongs_to :genre

  validates :photo_id, :genre_id, presence: true

end
