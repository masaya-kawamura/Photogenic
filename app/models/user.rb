class User < ApplicationRecord
  # =============== devise関連===================
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #========== carrierwaveとの紐つけ==============
  mount_uploader :profile_image, ProfileUploader
  mount_uploader :cover_image, CoverUploader

end
