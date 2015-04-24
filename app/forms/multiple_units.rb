class MultipleUnits
  include ActiveModel::Model

  class << self
    def i18n_scope
      :activerecord
    end
  end

  attr_accessor(:quantity,
                :name,
                :private_area,
                :common_area,
                :box_area,
                :exchanged,
                :project_id)

  def names
    names = []
    1.upto(self.quantity.to_i) do |i|
      names << "#{self.name} #{i.to_s.rjust(2, '0')}"      
    end
    names
  end

  validates :quantity, numericality: { greater_than_or_equal_to: 2 }
  validates :name, presence: true
  validate :verify_uniqueness_of_names
  validates :private_area, numericality: { greater_than_or_equal_to: 0 }
  validates :common_area, numericality: { greater_than_or_equal_to: 0 }
  validates :box_area, numericality: { greater_than_or_equal_to: 0 }
  validates :exchanged, inclusion: { in: [true, false], message: 'não pode ficar em branco' }
  validates :project_id, presence: true

  def verify_uniqueness_of_names
    existing_names = []
    Unit.where(name: self.names, project_id: self.project_id).each do |unit|
      existing_names << unit.name
    end

    if existing_names.length == 1
      errors.add :name, :names_already_taken_singular, existing_name: existing_names.first
    end

    if existing_names.length > 1
      errors.add :name, :names_already_taken_plural, existing_names: existing_names.sort.join(", ")
    end
  end
end