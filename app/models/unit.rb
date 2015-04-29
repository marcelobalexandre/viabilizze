class Unit < ActiveRecord::Base
  belongs_to :project

  validates :name, presence: true,
                   uniqueness: { scope: :project_id, case_sensitive: false }
  validates :private_area, numericality: { greater_than_or_equal_to: 0 }
  validates :common_area,  numericality: { greater_than_or_equal_to: 0 }
  validates :box_area,     numericality: { greater_than_or_equal_to: 0 }
  validates :exchanged,    inclusion: { in: [true, false], message: :blank }
  validates :project_id,   presence: true

  def total_area
    self.private_area + self.common_area + self.box_area
  end

  def self.by_name(name)
    if name.present? 
      where("name like ?", "%#{name}%").order(:name)
    else 
      order(:name)
    end
  end

  self.per_page = 10
end