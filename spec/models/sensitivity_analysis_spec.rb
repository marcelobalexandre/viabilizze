require 'spec_helper'
require 'rails_helper'

describe SensitivityAnalysis do
  let(:project) { FactoryGirl.create(:project) }
  subject(:sensitivity_analysis) { FactoryGirl.build(:sensitivity_analysis, project: project) }

  it { expect(subject).to respond_to(:name) }
  it { expect(subject).to respond_to(:net_profit_margin) }
  it { expect(subject).to respond_to(:expected_revenue) }
  it { expect(subject).to respond_to(:revenue) }
  it { expect(subject).to respond_to(:selling_price) }
  it { expect(subject).to respond_to(:sale_price) }
  it { expect(subject).to respond_to(:sales_commissions_rate) }
  it { expect(subject).to respond_to(:sales_commissions) }
  it { expect(subject).to respond_to(:sales_taxes_rate) }
  it { expect(subject).to respond_to(:sales_taxes) }
  it { expect(subject).to respond_to(:sales_charges_rate) }
  it { expect(subject).to respond_to(:sales_charges) }
  it { expect(subject).to respond_to(:individualization_costs) }
  it { expect(subject).to respond_to(:cost_per_square_meter) }
  it { expect(subject).to respond_to(:land_acquisition_cost) }
  it { expect(subject).to respond_to(:construction_costs) }
  it { expect(subject).to respond_to(:exchanged_units_construction_costs) }
  it { expect(subject).to respond_to(:exchanged_units_expenses) }
  it { expect(subject).to respond_to(:inss) }
  it { expect(subject).to respond_to(:markup) }
  it { expect(subject).to respond_to(:result) }
  it { expect(subject).to respond_to(:profit_rate) }
  it { expect(subject).to respond_to(:project_id) }
  it { expect(subject).to respond_to(:unit_sensitivity_analyses) }

  it { expect(subject).to belong_to(:project) }
  it { expect(subject).to have_many(:unit_sensitivity_analyses) }

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_uniqueness_of(:name).scoped_to(:project_id) }

  describe "when name is already taken from sensitivity analysis from another project" do
    before do
      another_project = FactoryGirl.create(:project)
      sensitivity_analysis_with_same_name = subject.dup
      sensitivity_analysis_with_same_name.project_id = another_project.id
      sensitivity_analysis_with_same_name.save
      subject.save
    end

    it { expect(subject).to be_valid }
  end

  it { expect(subject).to validate_presence_of(:project) }
end