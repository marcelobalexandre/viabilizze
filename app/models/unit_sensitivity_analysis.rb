class UnitSensitivityAnalysis < ActiveRecord::Base
  belongs_to :unit
  belongs_to :sensitivity_analysis

  validates :sale_price, numericality: { greater_than: 0 }, allow_blank: true
  validates :unit, presence: true
  validates :sensitivity_analysis, presence: true

  def selling_price
    calculate_and_return_zero_if_exchanged do
      to_sum = [self.individualization_costs,
                self.construction_costs,
                self.land_acquisition_cost,
                self.exchanged_units_construction_costs,
                self.exchanged_units_expenses]
      costs_and_expenses = to_sum.inject(0) { |sum, number| sum + number }
      (costs_and_expenses * self.sensitivity_analysis.markup).round(2)
    end
  end

  def sales_commissions
    calculate_and_return_zero_if_exchanged { (self.sale_price * (self.sensitivity_analysis.sales_commissions_rate.to_s.to_d / 100)).round(2) }
  end

  def sales_taxes
    calculate_and_return_zero_if_exchanged { (self.sale_price * (self.sensitivity_analysis.sales_taxes_rate.to_s.to_d / 100)).round(2) }
  end

  def sales_charges
    calculate_and_return_zero_if_exchanged { (self.sale_price * (self.sensitivity_analysis.sales_charges_rate.to_s.to_d / 100)).round(2) }
  end

  def individualization_costs
    calculate_and_return_zero_if_exchanged do
      (self.sensitivity_analysis.individualization_costs.to_s.to_d / self.sensitivity_analysis.project.total_units_not_exchanged).round(2)
    end
  end

  def land_acquisition_cost
    calculate_and_return_zero_if_exchanged { (self.sensitivity_analysis.land_acquisition_cost_per_total_area_not_exchanged * self.unit.total_area).round(2) }
  end

  def construction_costs
    (self.sensitivity_analysis.cost_per_square_meter.to_s.to_d * self.unit.total_area).round(2)
  end

  def exchanged_units_construction_costs
    calculate_and_return_zero_if_exchanged do
      (self.unit.total_area.to_s.to_d * self.sensitivity_analysis.exchanged_units_construction_costs_per_total_area_not_exchanged.to_s.to_d).round(2)
    end
  end

  def exchanged_units_expenses
    calculate_and_return_zero_if_exchanged { (self.unit.total_area * self.sensitivity_analysis.exchanged_units_expenses_per_total_area_not_exchanged).round(2) }
  end

  def result
    calculate_and_return_zero_if_exchanged do
      to_sum = [self.individualization_costs,
                self.construction_costs,
                self.land_acquisition_cost,
                self.exchanged_units_construction_costs,
                self.exchanged_units_expenses,
                self.sales_commissions,
                self.sales_taxes,
                self.sales_charges]
      total_costs_and_expenses = to_sum.inject(0) { |sum, number| sum + number }
      (self.sale_price - total_costs_and_expenses).round(2)
    end
  end

  def profit_rate
    calculate_and_return_zero_if_exchanged { ((self.result / self.sale_price) * 100).round(2) }
  end

  def completed
    if self.sale_price || self.unit.exchanged
      true
    else
      false
    end
  end

  private

  def calculate_and_return_zero_if_exchanged(&block)
    if self.unit.exchanged
      0.00
    else
      block.call
    end
  end
end
