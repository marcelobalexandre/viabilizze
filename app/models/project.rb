class Project < ActiveRecord::Base
  self.per_page = 10
  
  belongs_to :user
  has_many :units

  validates :name, presence: true,
                   uniqueness: { scope: :user_id, case_sensitive: false }
  validates :user_id, presence: true               
end
