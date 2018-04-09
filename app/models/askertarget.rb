class Askertarget < ActiveRecord::Base
  validates :asker_id, presence: true
  validates :target_id, presence: true
end
