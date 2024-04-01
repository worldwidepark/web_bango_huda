class User < ApplicationRecord
  before_create :set_uuid


  has_many :bango_hudas
  validates :email, presence: true, uniqueness: true



  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end
