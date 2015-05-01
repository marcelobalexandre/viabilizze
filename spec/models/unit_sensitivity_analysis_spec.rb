require 'spec_helper'
require 'rails_helper'

describe UnitSensitivityAnalysis do
  subject(:unit_sensitivity_analysis) { FactoryGirl.build(:unit_sensitivity_analysis) }

  it { expect(subject).to respond_to(:net_profit_margin) }
  it { expect(subject).to respond_to(:selling_price) }
  it { expect(subject).to respond_to(:sale_price) }
  it { expect(subject).to respond_to(:sales_commissions) }
  it { expect(subject).to respond_to(:sales_taxes) }
  it { expect(subject).to respond_to(:sales_charges) }
  it { expect(subject).to respond_to(:individualization_costs) }
  it { expect(subject).to respond_to(:land_acquisition_cost) }
  it { expect(subject).to respond_to(:construction_costs) }
  it { expect(subject).to respond_to(:exchanged_units_construction_costs) }
  it { expect(subject).to respond_to(:exchanged_units_expenses) }
  it { expect(subject).to respond_to(:inss) }
  it { expect(subject).to respond_to(:markup) }
  it { expect(subject).to respond_to(:result) }
  it { expect(subject).to respond_to(:profit_rate) }
  it { expect(subject).to respond_to(:unit_id) }
  it { expect(subject).to respond_to(:sensitivity_analysis_id) }

  it { expect(subject).to belong_to(:unit) }
  it { expect(subject).to belong_to(:sensitivity_analysis) }

  it { expect(subject).to validate_presence_of(:unit_id) }
  it { expect(subject).to validate_presence_of(:sensitivity_analysis_id) }
end