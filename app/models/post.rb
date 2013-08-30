class Post < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  searchable do
  	text :content
  	text :user do
  		[ user.name, user.email ]
  	end
    time :created_at
  end

  def self.from_followed_users(user)
		where("user_id IN (SELECT to_id FROM followings WHERE from_id = :user_id) OR user_id = :user_id", user_id: user.id)
  end
end
