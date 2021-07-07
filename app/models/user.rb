class User < ApplicationRecord
  # =============== devise関連===================
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #========== carrierwaveとの紐つけ==============
  mount_uploader :profile_image, ProfileUploader
  mount_uploader :cover_image, CoverUploader

  belongs_to :photographer, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :favorites, dependent: :destroy

  enum user_status: { '一般ユーザー': 0, 'フォトグラファー': 1, '退会済みユーザー': 2 }

end
