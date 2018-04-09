class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  default_scope -> { order('created_at DESC') }
  # validates :content, presence: true#, length: { maximum: 140 }
  validates :user_id, presence: true

  def comments_c
    self.comments.count
  end
end
