class SensitivityAnalysis < ActiveRecord::Base
  belongs_to :project
  has_many :unit_sensitivity_analyses, dependent: :destroy, inverse_of: :sensitivity_analysis
  accepts_nested_attributes_for :unit_sensitivity_analyses

  validates :name, presence: true,
                   uniqueness: { scope: :project_id, case_sensitive: false }
  validates :project, presence: true

  def expected_revenue
  end

  def revenue
  end

  def selling_price
  end

  def sale_price
  end

  def sales_commissions
  end

  def sales_taxes
  end

  def sales_charges
  end

  def construction_costs
  end

  def exchanged_units_construction_costs
  end

  def inss
  end

  def markup
  end

  def result
  end

  def profit_rate
  end

  self.per_page = 10
end
