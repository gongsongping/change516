class User < ActiveRecord::Base
  # store_accessor :json, :is_foing , :blog, :github, :twitter
  # validates_uniqueness_of :email, :message => '%{value} has already been taken'
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  # has_many :posts, dependent: :destroy
  has_many :stalkertargets, foreign_key: "stalker_id", dependent: :destroy
  has_many :targets, through: :stalkertargets, source: :target
  has_many :reverse_stalkertargets, foreign_key: "target_id",
                                   class_name:  "Stalkertarget",
                                   dependent:   :destroy
  has_many :stalkers, through: :reverse_stalkertargets, source: :stalker
  has_many :photos, dependent: :destroy
  has_many :cafeposts, dependent: :destroy
  has_many :products, dependent: :destroy

  before_save { self.email = email.downcase }
  validates :name,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
  def s_askers
    ids = Askertarget.where("target_id = ? and agree is not true", self.id).pluck(:asker_id)
    User.find(ids)
  end
  def s_targets
    ids = Askertarget.where("asker_id = ?  and agree is not true ", self.id).pluck(:target_id)
    User.find(ids)
  end
  def partners
    ids_a = Askertarget.where("target_id = ? and agree is true ", self.id).pluck(:asker_id)
    ids_b = Askertarget.where("asker_id = ? and agree is true ", self.id).pluck(:target_id)
    User.find(ids_a + ids_b)
  end
  def s_asker?(u)
    self.s_askers.include?(u)
  end
  def s_target?(u)
    self.s_targets.include?(u)
  end
  def partner?(u)
    self.partners.include?(u)
  end
end
