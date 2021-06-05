class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  attachment :profile_image
  has_many :post_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :reverse_of_relationships, source: :follower
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :relationships, source: :followed

  # ユーザーをフォローする
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  # ユーザーのフォローを外す
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  # フォローしていれば、trueを返す
  def following?(user)
    followings.include?(user)
  end


  validates :name, length: { in: 2..20 }, uniqueness: true
  validates :introduction, length: { maximum: 50 }

end
