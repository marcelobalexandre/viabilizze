class SensitivityAnalysis < ActiveRecord::Base
  belongs_to :project
  has_many :unit_sensitivity_analyses, dependent: :destroy, inverse_of: :sensitivity_analysis
  accepts_nested_attributes_for :unit_sensitivity_analyses

  validates :name, presence: true,
                   uniqueness: { scope: :project_id, case_sensitive: false }
  validates :net_profit_margin, numericality: { greater_than: 0 }, allow_blank: true
  validates :sales_commissions_rate, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :sales_taxes_rate, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :sales_charges_rate, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :individualization_costs, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :cost_per_square_meter, numericality: { greater_than: 0 }, allow_blank: true
  validates :land_acquisition_cost, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :exchanged_units_expenses, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :project, presence: true

  def expected_revenue
    (self.unit_sensitivity_analyses.inject(0) { |sum, unit_sensitivity_analysis| sum + unit_sensitivity_analysis.selling_price }).round(2)
  end

  def revenue
    (not_exchanged_units.inject(0) { |sum, unit_sensitivity_analysis| sum + unit_sensitivity_analysis.sale_price}).round(2)
  end

  def sales_commissions
    (self.unit_sensitivity_analyses.inject(0) { |sum, unit_sensitivity_analysis| sum + unit_sensitivity_analysis.sales_commissions }).round(2)
  end

  def sales_taxes
    (self.unit_sensitivity_analyses.inject(0) { |sum, unit_sensitivity_analysis| sum + unit_sensitivity_analysis.sales_taxes }).round(2)
  end

  def sales_charges
    (self.unit_sensitivity_analyses.inject(0) { |sum, unit_sensitivity_analysis| sum + unit_sensitivity_analysis.sales_charges }).round(2)
  end

  def land_acquisition_cost_per_total_area_not_exchanged
    division_by_total_area_not_exchanged(self.land_acquisition_cost)
  end

  def construction_costs
    (self.unit_sensitivity_analyses.inject(0) { |sum, unit_sensitivity_analysis| sum + unit_sensitivity_analysis.construction_costs }).round(2)
  end

  def exchanged_units_construction_costs
    exchanged_units = self.unit_sensitivity_analyses.select { |unit_sensitivity_analysis| unit_sensitivity_analysis.unit.exchanged }
    (exchanged_units.inject(0) { |sum, unit_sensitivity_analysis| sum + unit_sensitivity_analysis.construction_costs }).round(2)
  end

  def exchanged_units_construction_costs_per_total_area_not_exchanged
    (self.exchanged_units_construction_costs / self.project.total_area_not_exchanged).round(2)
  end

  def exchanged_units_expenses_per_total_area_not_exchanged
    division_by_total_area_not_exchanged(self.exchanged_units_expenses)
  end

  def total_exchanged_units_costs
    (self.exchanged_units_construction_costs.to_s.to_d + self.exchanged_units_expenses.to_s.to_d).round(2)
  end

  def total_construction_and_sales_costs
    to_sum = [self.construction_costs,
              self.individualization_costs,
              self.land_acquisition_cost,
              self.sales_commissions,
              self.sales_taxes,
              self.sales_charges,
              self.exchanged_units_expenses]
    (to_sum.inject(0) { |sum, number| sum + number.to_s.to_d }).round(2)
  end

  def markup
    to_sum = [self.sales_commissions_rate, self.sales_taxes_rate, self.sales_charges_rate, self.net_profit_margin]
    total_percentage = to_sum.inject(0) { |sum, number| sum + number.to_s.to_d }
    (100 / (100 - total_percentage)).round(5)
  end

  def expected_result
    (self.expected_revenue * (self.net_profit_margin / 100)).round(2)
  end

  def result
    (self.unit_sensitivity_analyses.inject(0) { |sum, unit_sensitivity_analysis| sum + unit_sensitivity_analysis.result }).round(2)
  end

  def average_profit_rate
    total_profit_rate = not_exchanged_units.inject(0) { |sum, unit_sensitivity_analysis| sum + unit_sensitivity_analysis.profit_rate}
    (total_profit_rate / self.project.total_units_not_exchanged).round(2)
  end

  def completed
    if (!self.name.blank? && self.net_profit_margin && self.cost_per_square_meter &&
        !self.unit_sensitivity_analyses.any? { |unit_sensitivity_analysis| !unit_sensitivity_analysis.completed })
      true
    else
      false
    end
  end

  self.per_page = 10

  private

  def not_exchanged_units
    self.unit_sensitivity_analyses.select { |unit_sensitivity_analysis| !unit_sensitivity_analysis.unit.exchanged }
  end

  def division_by_total_area_not_exchanged(number)
    if number.to_s.to_d == 0 || self.project.total_area_not_exchanged.to_s.to_d == 0
      return 0.00
    end

    (number / self.project.total_area_not_exchanged).round(2)
  end
end