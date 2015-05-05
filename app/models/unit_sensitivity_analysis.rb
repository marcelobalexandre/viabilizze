class UnitSensitivityAnalysis < ActiveRecord::Base
  belongs_to :unit
  belongs_to :sensitivity_analysis

  validates :unit, presence: true
  validates :sensitivity_analysis, presence: true

  def net_profit_margin
  end

  def selling_price
  end

  def sales_commissions
  end

  def sales_taxes
  end

  def sales_charges
  end

  def individualization_costs
  end

  def land_acquisition_cost
  end

  def construction_costs
  end

  def exchanged_units_construction_costs
  end

  def exchanged_units_expenses
  end

  def inss
  end

  def markup
  end

  def result
  end

  def profit_rate
  end
end
