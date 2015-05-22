class Project < ActiveRecord::Base
  belongs_to :user
  has_many :units, dependent: :destroy
  has_many :sensitivity_analyses, dependent: :destroy

  validates :name, presence: true,
                   uniqueness: { scope: :user_id, case_sensitive: false }
  validates :user, presence: true

  def total_units_not_exchanged
    self.units.select { |unit| !unit.exchanged }.count

  end

  def total_area_not_exchanged
    self.units.select { |unit| !unit.exchanged }.inject(0) { |sum, unit| sum + unit.total_area }
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
