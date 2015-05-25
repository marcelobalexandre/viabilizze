class UnitSensitivityAnalysis < ActiveRecord::Base
  belongs_to :unit
  belongs_to :sensitivity_analysis

  validates :unit, presence: true
  validates :sensitivity_analysis, presence: true

  def selling_price
    selling_price = ((self.individualization_costs + self.construction_costs + self.land_acquisition_cost +
                      self.exchanged_units_construction_costs + self.exchanged_units_expenses) *
                     self.sensitivity_analysis.markup).round(2)
    self.unit.exchanged ? 0.00 : selling_price
  end

  def sales_commissions
    sales_commissions = (self.sale_price * (self.sensitivity_analysis.sales_commissions_rate / 100)).round(2)
    self.unit.exchanged ? 0.00 : sales_commissions
  end

  def sales_taxes
    sales_taxes = (self.sale_price * (self.sensitivity_analysis.sales_taxes_rate / 100)).round(2)
    self.unit.exchanged ? 0.00 : sales_taxes
  end

  def sales_charges
    sales_charges = (self.sale_price * (self.sensitivity_analysis.sales_charges_rate / 100)).round(2)
    self.unit.exchanged ? 0.00 : sales_charges
  end

  def individualization_costs
    unless self.sensitivity_analysis.individualization_costs
      return 0.00
    end

    individualization_costs = (self.sensitivity_analysis.individualization_costs /
                               self.sensitivity_analysis.project.total_units_not_exchanged).round(2)
    self.unit.exchanged ? 0.00 : individualization_costs
  end

  def land_acquisition_cost
    unless self.sensitivity_analysis.land_acquisition_cost_per_total_area_not_exchanged
      return 0.00
    end

    land_acquisition_cost = (self.sensitivity_analysis.land_acquisition_cost_per_total_area_not_exchanged * self.unit.total_area).round(2)
    self.unit.exchanged ? 0.00 : land_acquisition_cost
  end

  def construction_costs
    unless self.sensitivity_analysis.cost_per_square_meter
      return 0.00
    end

    (self.sensitivity_analysis.cost_per_square_meter * self.unit.total_area).round(2)
  end

  def exchanged_units_construction_costs
    unless self.sensitivity_analysis.exchanged_units_construction_costs_per_total_area_not_exchanged
      return 0.00
    end

    exchanged_units_construction_costs = (self.unit.total_area *
                                          self.sensitivity_analysis.exchanged_units_construction_costs_per_total_area_not_exchanged).round(2)
    self.unit.exchanged ? 0.00 : exchanged_units_construction_costs
  end

  def exchanged_units_expenses
    unless self.sensitivity_analysis.exchanged_units_expenses_per_total_area_not_exchanged
      return 0.00
    end

    exchanged_units_expenses = (self.unit.total_area * self.sensitivity_analysis.exchanged_units_expenses_per_total_area_not_exchanged).round(2)
    self.unit.exchanged ? 0.00 : exchanged_units_expenses
  end

  def result
    if self.unit.exchanged
      0.00
    else
      (self.sale_price - self.individualization_costs - self.construction_costs -
       self.land_acquisition_cost - self.exchanged_units_construction_costs - self.exchanged_units_expenses -
       self.sales_commissions - self.sales_taxes - self.sales_charges).round(2)
    end
  end

  def profit_rate
    if self.unit.exchanged
      0.00
    else
      ((self.result / self.sale_price) * 100).round(2)
    end
  end
end
