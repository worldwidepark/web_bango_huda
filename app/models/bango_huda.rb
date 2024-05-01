class BangoHuda < ApplicationRecord
  before_create :set_uuid
  belongs_to :user

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
