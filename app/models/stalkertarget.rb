class Stalkertarget < ActiveRecord::Base
  belongs_to :stalker, class_name: "User"
  belongs_to :target, class_name: "User"
  validates :stalker_id, presence: true
  validates :target_id, presence: true
end
