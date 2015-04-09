class User < ActiveRecord::Base
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  has_many :projects

  validates :name, presence: true,
                   length: { in: 3..35 }

  validates :email, length: { maximum: 100}
end
