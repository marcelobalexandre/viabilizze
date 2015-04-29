class Project < ActiveRecord::Base
  belongs_to :user
  has_many :units, dependent: :delete_all
  has_many :sensitivity_analyses, dependent: :delete_all

  validates :name, presence: true,
                   uniqueness: { scope: :user_id, case_sensitive: false }
  validates :user_id, presence: true

  def self.by_name(name)
    if name.present?
      where("name like ?", "%#{name}%").order(:name)
    else
      order(:name)
    end
  end

  self.per_page = 10
end
