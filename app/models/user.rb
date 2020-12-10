class User < ApplicationRecord
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
            uniqueness: { case_sensitive: false }
  has_secure_password

  has_many :microposts
  has_many :relationships
  has_many :followings, through: :relationships, source: :follow
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  has_many :favorite_microposts, through: :favorites, source: :micropost
  #has_many :micropostsは最初に使ってしまったので「has_many任意の名称にして記載する
  #throughは中間テーブル名、sourceは「models」フォルダの中の各ファイルに記載されている
  #「belongs_to」のところの記載に合わせる
  has_many :reverses_of_favorite, class_name: 'Favorites', foreign_key: 'user_id'

  def follow(other_user)
    #フォローしようとしている other_user が自分自身ではないかを検証
    unless self == other_user
      #find_or_create_byのあとはテーブルのカラム名
      self.relationships.find_or_create_by(follow_id: other_user.id)
    #実行した User のインスタンスが self
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end

 #selfにはfavorite(other)を実行したときにmicropostが代入される
  def like(other_micropost)
     current_user.find_or_create_by(@microposts)
  end
 
 #selfにはunfavorite(other)を実行したときにmicropostが代入される
  def likeing(other_micropost)
    self.like.find_by(micropost_id: other_micropost.id)
    #実行したmicropostのインスタンスが self
    like.destroy if like
  end

  def like?(other_micropost)
    self.like.include?(other_micropost)
  end
end