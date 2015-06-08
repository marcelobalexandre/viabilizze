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
  validates :email, presence: true,
                    length: { maximum: 100}
  validates :password, presence: true
  validates :password_confirmation, presence: true
end
