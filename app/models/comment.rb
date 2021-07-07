class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :photo

  validates :user_id, :photo_id, presence: true
  validates :comment, presence: true, length: { in: 2..140 }

end
