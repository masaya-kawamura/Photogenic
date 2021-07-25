class User < ApplicationRecord
  enum user_status: { '一般ユーザー': 0, 'フォトグラファー': 1, '退会済みユーザー': 2 }

  # =============== devise関連===================
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :omniauthable

  #========== carrierwaveとの紐つけ==============
  mount_uploader :profile_image, ProfileUploader

  # =========== 各モデルとの関連付け ============
  has_one :photographer, dependent: :destroy
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
  has_many :rates, dependent: :destroy

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

  # ======= 評価してるかどうか検証するメソッド =========
  def not_rated?(photo)
    rates.find_by(photo_id: photo.id).nil?
  end

  # ======= バリデーションの設定 ================
  validates :name, :email, presence: true

  # ======== SNSログイン認証 =============
  def self.form_omniauth(auth)
    find_or_create_by(provider: auth["provider"], uid: auth["uid"]) do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["nickname"]
    end
  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"]) do |user|
        user.attributes = params
      end
    else
      super
    end
  end

  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first

    unless user
      user = User.create(
        uid: auth.uid,
        provider: auth.provider,
        email: User.dummy_email(auth),
        password: Devise.friendly_token[0, 20]
      )
    end
    user.skip_confirmation!
    user
  end
  
    private
    
    def self.dummy_email(auth)
      "#{auth.uid}-#{auth.provider}@example.com"
    end

end
