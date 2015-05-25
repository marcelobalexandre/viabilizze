class SensitivityAnalysis < ActiveRecord::Base
  belongs_to :project
  has_many :unit_sensitivity_analyses, dependent: :destroy, inverse_of: :sensitivity_analysis
  accepts_nested_attributes_for :unit_sensitivity_analyses

  validates :name, presence: true,
                   uniqueness: { scope: :project_id, case_sensitive: false }
  validates :project, presence: true

  def expected_revenue
    (self.unit_sensitivity_analyses.inject(0) { |sum, unit_sensitivity_analysis| sum + unit_sensitivity_analysis.selling_price }).round(2)
  end

  def revenue
    (self.unit_sensitivity_analyses.inject(0) do |sum, unit_sensitivity_analysis|
      if !unit_sensitivity_analysis.unit.exchanged
       sum + unit_sensitivity_analysis.sale_price
      else
        sum
      end
    end).round(2)
  end

  def sales_commissions
    (self.unit_sensitivity_analyses.inject(0) do |sum, unit_sensitivity_analysis|
      if !unit_sensitivity_analysis.unit.exchanged
       sum + unit_sensitivity_analysis.sales_commissions
      else
        sum
      end
    end).round(2)
  end

  def sales_taxes
    (self.unit_sensitivity_analyses.inject(0) do |sum, unit_sensitivity_analysis|
      if !unit_sensitivity_analysis.unit.exchanged
       sum + unit_sensitivity_analysis.sales_taxes
      else
        sum
      end
    end).round(2)
  end

  def sales_charges
    (self.unit_sensitivity_analyses.inject(0) do |sum, unit_sensitivity_analysis|
      if !unit_sensitivity_analysis.unit.exchanged
       sum + unit_sensitivity_analysis.sales_charges
      else
        sum
      end
    end).round(2)
  end

  def land_acquisition_cost_per_total_area_not_exchanged
    unless self.land_acquisition_cost
      return 0.00
    end

    (self.land_acquisition_cost / self.project.total_area_not_exchanged).round(2)
  end

  def construction_costs
    (self.unit_sensitivity_analyses.inject(0) { |sum, unit_sensitivity_analysis| sum + unit_sensitivity_analysis.construction_costs }).round(2)
  end

  def exchanged_units_construction_costs
    unless self.unit_sensitivity_analyses.any? { |unit_sensitivity_analysis| unit_sensitivity_analysis.unit.exchanged }
      return 0.00
    end

    (self.unit_sensitivity_analyses.select do |unit_sensitivity_analysis|
       unit_sensitivity_analysis.unit.exchanged
     end.inject(0) { |sum, unit_sensitivity_analysis| sum + unit_sensitivity_analysis.construction_costs }).round(2)
  end

  def exchanged_units_construction_costs_per_total_area_not_exchanged
    (self.exchanged_units_construction_costs / self.project.total_area_not_exchanged).round(2)
  end

  def exchanged_units_expenses_per_total_area_not_exchanged
    unless self.exchanged_units_expenses
      return 0.00
    end

    (self.exchanged_units_expenses / self.project.total_area_not_exchanged).round(2)
  end

  def total_exchanged_units_costs
    (self.exchanged_units_construction_costs + self.exchanged_units_expenses).round(2)
  end

  def total_construction_and_sales_costs
    (self.construction_costs + self.individualization_costs +
     self.land_acquisition_cost + self.sales_commissions + self.sales_taxes +
     self.sales_charges + self.exchanged_units_expenses).round(2)
  end

  def markup
    unless self.sales_commissions_rate && self.sales_taxes_rate && self.sales_charges_rate && self.net_profit_margin
      return 0.00
    end

    (100 / (100 - self.sales_commissions_rate - self.sales_taxes_rate - self.sales_charges_rate - self.net_profit_margin)).round(5)
  end

  def expected_result
    (self.expected_revenue * (self.net_profit_margin / 100)).round(2)
  end

  def result
    (self.unit_sensitivity_analyses.inject(0) { |sum, unit_sensitivity_analysis| sum + unit_sensitivity_analysis.result }).round(2)
  end

  def average_profit_rate
    sum = 0
    count = 0
    self.unit_sensitivity_analyses.select { |unit_sensitivity_analysis| !unit_sensitivity_analysis.unit.exchanged }.each do |unit_sensitivity_analysis|
      if unit_sensitivity_analysis.profit_rate != 0
        sum += unit_sensitivity_analysis.profit_rate
        count += 1
      end
    end
    (sum / count).round(2)
  end

  self.per_page = 10
end