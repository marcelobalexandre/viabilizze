class Project < ActiveRecord::Base
  self.per_page = 10
  
  belongs_to :user

  validates :name, presence: true,
                   uniqueness: { scope: :user_id, case_sensitive: false }
  validates :user_id, presence: true               
end
