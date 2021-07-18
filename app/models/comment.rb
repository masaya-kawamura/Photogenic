class Comment < ApplicationRecord

  belongs_to :user
  belongs_to :photo

  validates :comment, presence: true
  validates :comment, length: { in: 2..140 }

end
