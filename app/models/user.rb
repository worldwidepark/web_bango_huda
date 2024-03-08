class User < ApplicationRecord
  has_many :bango_hudas
  validates :email, presence: true, uniqueness: true
end
