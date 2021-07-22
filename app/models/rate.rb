class Rate < ApplicationRecord
  belongs_to :photo
  belongs_to :user

  validates :rate, presence: true
  validates :comment, length: { maximum: 400 }
end
