class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :books, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :relationships, dependent: :destroy

  # フォロー機能アソシエーション-start-

  has_many :relationships

  # followingsは適当な命名
  # through: :relationships は「中間テーブルはrelationships」設定
  has_many :followings, through: :relationships, source: :follow

  # reverse_of_relationshipsは適当な命名
  # foreign_key: 'follow_id'はrelaitonshipsテーブルにアクセスする時、follow_idを入口として来てねの意
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'
  
  # followersは適当な命名
  # through: :reverses_of_relationshipは「中間テーブルはreverses_of_relationship」設定
  has_many :followers, through: :reverse_of_relationships, source: :user
  
  # フォロー機能アソシエーション-finish-

  # フォロー機能メソッド-start-
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end
  # フォロー機能メソッド-finish-

  attachment :profile_image, destroy: false


  #バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, length: {maximum: 20, minimum: 2}
  validates :introduction, length: {maximum:50}
end
