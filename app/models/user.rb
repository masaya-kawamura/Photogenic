class User < ApplicationRecord

  enum user_status: { '一般ユーザー': 0, 'フォトグラファー': 1, '退会済みユーザー': 2 }

  # =============== devise関連===================
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  #========== carrierwaveとの紐つけ==============
  mount_uploader :profile_image, ProfileUploader
  mount_uploader :cover_image, CoverUploader

  # =========== 各モデルとの関連付け ============
  belongs_to :photographer, optional: true, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship',
                                 foreign_key: "follower_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :passive_relationships, class_name: 'Relationship',
                                  foreign_key: "followed_id",
                                    dependent: :destroy
  has_many :follower, through: :passive_relationships, source: :follower

  # ========== フォロワー関連メソッド============
  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

end