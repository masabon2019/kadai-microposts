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
 
  #fevorites
  #self.favorites (自分がお気に入り登録しているfavoriteテーブルのデータ行)
  has_many :favorites
  
  #self.favorite_posts (自分がお気に入り登録しているmicropostのデータ行)
  has_many :favorite_posts, through: :favorites, source: :micropost
  
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
  
  def feed_microposts
    Micropost.where(user_id: self.following_ids + [self.id])
  end
  
  #favorite お気に入り登録をするメソッド
  def favorite(favorite_post)
    self.favorites.find_or_create_by(micropost_id: favorite_post[:id])
  end
  
  # お気に入りから外すメソッド
  def unfavorite(favorite_post)
    favorite = self.favorites.find_by(micropost_id: favorite_post[:id])
    favorite.destroy if favorite
  end
  
  def favorite?(micropost)
    #favorite_postsはmicropostが複数格納された配列
    #include?メソッドは配列の中から引数で渡されたものと同じものがあるかどうか判別してくれるメソッド
    #すなわち引数にはmicropostを渡して上げる必要がある
    self.favorite_posts.include?(micropost)
  end

end