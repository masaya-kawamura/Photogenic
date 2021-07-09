class PhotoGenreMap < ApplicationRecord

  belongs_to :photo
  belongs_to :genre

end
