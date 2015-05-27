require 'spec_helper'
require 'rails_helper'

describe SensitivityAnalysis do
  let(:project) { FactoryGirl.create(:project) }
  subject(:sensitivity_analysis) { FactoryGirl.build(:sensitivity_analysis, project: project) }

  it { expect(subject).to respond_to(:name) }
  it { expect(subject).to respond_to(:net_profit_margin) }
  it { expect(subject).to respond_to(:expected_revenue) }
  it { expect(subject).to respond_to(:revenue) }
  it { expect(subject).to respond_to(:sales_commissions_rate) }
  it { expect(subject).to respond_to(:sales_commissions) }
  it { expect(subject).to respond_to(:sales_taxes_rate) }
  it { expect(subject).to respond_to(:sales_taxes) }
  it { expect(subject).to respond_to(:sales_charges_rate) }
  it { expect(subject).to respond_to(:sales_charges) }
  it { expect(subject).to respond_to(:individualization_costs) }
  it { expect(subject).to respond_to(:cost_per_square_meter) }
  it { expect(subject).to respond_to(:land_acquisition_cost) }
  it { expect(subject).to respond_to(:land_acquisition_cost_per_total_area_not_exchanged) }
  it { expect(subject).to respond_to(:construction_costs) }
  it { expect(subject).to respond_to(:exchanged_units_construction_costs) }
  it { expect(subject).to respond_to(:exchanged_units_construction_costs_per_total_area_not_exchanged) }
  it { expect(subject).to respond_to(:exchanged_units_expenses) }
  it { expect(subject).to respond_to(:exchanged_units_expenses_per_total_area_not_exchanged) }
  it { expect(subject).to respond_to(:total_exchanged_units_costs) }
  it { expect(subject).to respond_to(:total_construction_and_sales_costs) }
  it { expect(subject).to respond_to(:markup) }
  it { expect(subject).to respond_to(:expected_result) }
  it { expect(subject).to respond_to(:result) }
  it { expect(subject).to respond_to(:average_profit_rate) }
  it { expect(subject).to respond_to(:project_id) }
  it { expect(subject).to respond_to(:unit_sensitivity_analyses) }
  it { expect(subject).to respond_to(:completed) }

  it { expect(subject).to belong_to(:project) }
  it { expect(subject).to have_many(:unit_sensitivity_analyses) }

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_numericality_of(:net_profit_margin).is_greater_than(0) }
  it { expect(subject).to allow_value("", nil).for(:net_profit_margin) }
  it { expect(subject).to validate_numericality_of(:sales_commissions_rate).is_greater_than_or_equal_to(0) }
  it { expect(subject).to allow_value("", nil).for(:sales_commissions_rate) }
  it { expect(subject).to validate_numericality_of(:sales_taxes_rate).is_greater_than_or_equal_to(0) }
  it { expect(subject).to allow_value("", nil).for(:sales_taxes_rate) }
  it { expect(subject).to validate_numericality_of(:sales_charges_rate).is_greater_than_or_equal_to(0) }
  it { expect(subject).to allow_value("", nil).for(:sales_charges_rate) }
  it { expect(subject).to validate_numericality_of(:individualization_costs).is_greater_than_or_equal_to(0) }
  it { expect(subject).to allow_value("", nil).for(:individualization_costs) }
  it { expect(subject).to validate_numericality_of(:cost_per_square_meter).is_greater_than(0) }
  it { expect(subject).to allow_value("", nil).for(:cost_per_square_meter) }
  it { expect(subject).to validate_numericality_of(:land_acquisition_cost).is_greater_than_or_equal_to(0) }
  it { expect(subject).to allow_value("", nil).for(:land_acquisition_cost) }
  it { expect(subject).to validate_numericality_of(:exchanged_units_expenses).is_greater_than_or_equal_to(0) }
  it { expect(subject).to allow_value("", nil).for(:exchanged_units_expenses) }
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

  describe "#expected_revenue" do
    [ # unit_one_selling_price | unit_two_selling_price | unit_three_selling_price | expected_revenue
      [                 100.00,                  100.00,                    100.00,            300.00 ],
      [                1234.56,                 3500.23,                      0.00,           4734.79 ],
      [                2400.21,                 3500.20,                   2222.22,           8122.63 ]
    ].each do |unit_one_selling_price, unit_two_selling_price, unit_three_selling_price, expected_revenue|
      # Formula: sum all units selling price
      it "calculates the expected revenue" do
        unit_one_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_one_sensitivity_analysis).to receive(:selling_price).and_return(unit_one_selling_price)
        unit_two_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_two_sensitivity_analysis).to receive(:selling_price).and_return(unit_two_selling_price)
        unit_three_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_three_sensitivity_analysis).to receive(:selling_price).and_return(unit_three_selling_price)
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis)
        sensitivity_analysis.unit_sensitivity_analyses << unit_one_sensitivity_analysis
        sensitivity_analysis.unit_sensitivity_analyses << unit_two_sensitivity_analysis
        sensitivity_analysis.unit_sensitivity_analyses << unit_three_sensitivity_analysis

        expect(sensitivity_analysis.expected_revenue).to eq(expected_revenue)
      end
    end
  end

  describe "#revenue" do
    [ # unit_one_sale_price | unit_two_sale_price | unit_three_sale_price | revenue
      [              100.00,               100.00,                 100.00,   300.00 ],
      [             1234.56,              3500.23,                   0.00,  4734.79 ],
      [             2400.21,              3500.20,                2222.22,  8122.63 ]
    ].each do |unit_one_sale_price, unit_two_sale_price, unit_three_sale_price, revenue|
      # Formula: sum all units sale price
      it "calculates the revenue" do
        unit_one_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_one_sensitivity_analysis).to receive(:sale_price).and_return(unit_one_sale_price)
        unit_two_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_two_sensitivity_analysis).to receive(:sale_price).and_return(unit_two_sale_price)
        unit_three_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_three_sensitivity_analysis).to receive(:sale_price).and_return(unit_three_sale_price)
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis)
        sensitivity_analysis.unit_sensitivity_analyses << unit_one_sensitivity_analysis
        sensitivity_analysis.unit_sensitivity_analyses << unit_two_sensitivity_analysis
        sensitivity_analysis.unit_sensitivity_analyses << unit_three_sensitivity_analysis

        expect(sensitivity_analysis.revenue).to eq(revenue)
      end
    end
  end

  describe "#sales_commissions" do
    [ # unit_one_sales_commissions | unit_two_sales_commissions | unit_three_sales_commissions | sales_commissions
      [                     100.00,                      100.00,                        100.00,            300.00 ],
      [                    1234.56,                     3500.23,                          0.00,           4734.79 ],
      [                    2400.21,                     3500.20,                       2222.22,           8122.63 ]
    ].each do |unit_one_sales_commissions, unit_two_sales_commissions, unit_three_sales_commissions, sales_commissions|
      # Formula: sum all units sales commissions
      it "calculates the sales commissions" do
        unit_one_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_one_sensitivity_analysis).to receive(:sales_commissions).and_return(unit_one_sales_commissions)
        unit_two_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_two_sensitivity_analysis).to receive(:sales_commissions).and_return(unit_two_sales_commissions)
        unit_three_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_three_sensitivity_analysis).to receive(:sales_commissions).and_return(unit_three_sales_commissions)
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis)
        sensitivity_analysis.unit_sensitivity_analyses << unit_one_sensitivity_analysis
        sensitivity_analysis.unit_sensitivity_analyses << unit_two_sensitivity_analysis
        sensitivity_analysis.unit_sensitivity_analyses << unit_three_sensitivity_analysis

        expect(sensitivity_analysis.sales_commissions).to eq(sales_commissions)
      end
    end
  end

  describe "#sales_taxes" do
    [ # unit_one_sales_taxes | unit_two_sales_taxes | unit_three_sales_taxes | sales_taxes
      [               100.00,                100.00,                  100.00,       300.00 ],
      [              1234.56,               3500.23,                    0.00,      4734.79 ],
      [              2400.21,               3500.20,                 2222.22,      8122.63 ]
    ].each do |unit_one_sales_taxes, unit_two_sales_taxes, unit_three_sales_taxes, sales_taxes|
      # Formula: sum all units sales taxes
      it "calculates the sales taxes" do
        unit_one_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_one_sensitivity_analysis).to receive(:sales_taxes).and_return(unit_one_sales_taxes)
        unit_two_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_two_sensitivity_analysis).to receive(:sales_taxes).and_return(unit_two_sales_taxes)
        unit_three_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_three_sensitivity_analysis).to receive(:sales_taxes).and_return(unit_three_sales_taxes)
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis)
        sensitivity_analysis.unit_sensitivity_analyses << unit_one_sensitivity_analysis
        sensitivity_analysis.unit_sensitivity_analyses << unit_two_sensitivity_analysis
        sensitivity_analysis.unit_sensitivity_analyses << unit_three_sensitivity_analysis

        expect(sensitivity_analysis.sales_taxes).to eq(sales_taxes)
      end
    end
  end

  describe "#sales_charges" do
    [ # unit_one_sales_charges | unit_two_sales_charges | unit_three_sales_charges | sales_charges
      [                 100.00,                  100.00,                    100.00,         300.00 ],
      [                1234.56,                 3500.23,                      0.00,        4734.79 ],
      [                2400.21,                 3500.20,                   2222.22,        8122.63 ]
    ].each do |unit_one_sales_charges, unit_two_sales_charges, unit_three_sales_charges, sales_charges|
      # Formula: sum all units sales charges
      it "calculates the sales charges" do
        unit_one_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_one_sensitivity_analysis).to receive(:sales_charges).and_return(unit_one_sales_charges)
        unit_two_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_two_sensitivity_analysis).to receive(:sales_charges).and_return(unit_two_sales_charges)
        unit_three_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_three_sensitivity_analysis).to receive(:sales_charges).and_return(unit_three_sales_charges)
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis)
        sensitivity_analysis.unit_sensitivity_analyses << unit_one_sensitivity_analysis
        sensitivity_analysis.unit_sensitivity_analyses << unit_two_sensitivity_analysis
        sensitivity_analysis.unit_sensitivity_analyses << unit_three_sensitivity_analysis

        expect(sensitivity_analysis.sales_charges).to eq(sales_charges)
      end
    end
  end

  describe "#land_acquisition_cost_per_total_area_not_exchanged" do
    [ # land_acquisition_cost | total_area_not_exchanged | land_acquisition_cost_per_not_exchanged_units
      [               4000.00,                    708.21,                                           5.65 ],
      [               3875.23,                    801.23,                                           4.84 ],
      [               5201.02,                    600.00,                                           8.67 ],
      [               5201.02,                       nil,                                           0.00 ],
      [                   nil,                    600.00,                                           0.00 ]
    ].each do |land_acquisition_cost, total_area_not_exchanged, land_acquisition_cost_per_total_area_not_exchanged|
      # Formula: land_acquisition_cost / project.total_area_not_exchanged
      it "calculates the land acquisition cost per total area not exchanged" do
        project = FactoryGirl.build(:project)
        allow(project).to receive(:total_area_not_exchanged).and_return(total_area_not_exchanged)
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis, project: project,
                                                                        land_acquisition_cost: land_acquisition_cost)

        expect(sensitivity_analysis.land_acquisition_cost_per_total_area_not_exchanged).to eq(land_acquisition_cost_per_total_area_not_exchanged)
      end
    end
  end

  describe "#construction_costs" do
    [ # units | unit_construction_costs | construction_costs
      [     1,                  4000.00,             4000.00 ],
      [     3,                  2341.22,             7023.66 ]
    ].each do |units, unit_construction_costs, construction_costs|
      # Formula: sum all units construction_costs
      it "calculates the construction costs" do
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis)
        units.times do
          unit_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
          allow(unit_sensitivity_analysis).to receive(:construction_costs).and_return(unit_construction_costs)
          sensitivity_analysis.unit_sensitivity_analyses << unit_sensitivity_analysis
        end

        expect(sensitivity_analysis.construction_costs).to eq(construction_costs)
      end
    end
  end

  describe "#exchanged_units_construction_costs" do
    [ # not_exchanged | not_exchanged_construction_costs | exchanged | exchanged_construction_costs | exchanged_units_construction_costs
      [             3,                            100.00,          1,                         200.00,                              200.00 ],
      [             4,                            201.23,          2,                         123.98,                              247.96 ],
      [             4,                            201.23,          0,                           0.00,                                0.00 ]
    ].each do |not_exchanged, not_exchanged_construction_costs, exchanged, exchanged_construction_costs, exchanged_units_construction_costs|
      # Formula: sum the construction costs of all exchanged units
      it "calculates the exchanged units construction costs" do
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis)
        not_exchanged.times do
          unit = FactoryGirl.build(:unit, exchanged: false)
          unit_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis, unit: unit)
          allow(unit_sensitivity_analysis).to receive(:construction_costs).and_return(not_exchanged_construction_costs)
          sensitivity_analysis.unit_sensitivity_analyses << unit_sensitivity_analysis
        end
        exchanged.times do
          unit = FactoryGirl.build(:unit, exchanged: true)
          unit_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis, unit: unit)
          allow(unit_sensitivity_analysis).to receive(:construction_costs).and_return(exchanged_construction_costs)
          sensitivity_analysis.unit_sensitivity_analyses << unit_sensitivity_analysis
        end

        expect(sensitivity_analysis.exchanged_units_construction_costs).to eq(exchanged_units_construction_costs)
      end
    end
  end

  describe "#exchanged_units_construction_costs_per_total_area_not_exchanged" do
    [ # exchanged_units_construction_costs | total_area_not_exchanged | exchanged_units_construction_costs_per_total_area_not_exchanged
      [                            2000.00,                  150.00,                                                         13.33 ],
      [                            3241.87,                  521.34,                                                          6.22 ]
    ].each do |exchanged_units_construction_costs, total_area_not_exchanged, exchanged_units_construction_costs_per_total_area_not_exchanged|
      # Formula: exchanged_units_construction_costs / project.total_area_not_exchanged
      it "calculates the exchanged units construction costs per total area not exchanged" do
        project = FactoryGirl.build(:project)
        allow(project).to receive(:total_area_not_exchanged).and_return(total_area_not_exchanged)
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis, project: project)
        allow(sensitivity_analysis).to receive(:exchanged_units_construction_costs).and_return(exchanged_units_construction_costs)

        expect(sensitivity_analysis.exchanged_units_construction_costs_per_total_area_not_exchanged).to eq(exchanged_units_construction_costs_per_total_area_not_exchanged)
      end
    end
  end

  describe "#exchanged_units_expenses_per_total_area_not_exchanged" do
    [ # exchanged_units_expenses | total_area_not_exchanged | exchanged_units_expenses_per_total_area_not_exchanged
      [                  2000.00,                    150.00,                                                  13.33 ],
      [                  3241.87,                    521.34,                                                   6.22 ],
      [                  3241.87,                       nil,                                                   0.00 ],
      [                      nil,                    100.00,                                                   0.00 ],
    ].each do |exchanged_units_expenses, total_area_not_exchanged, exchanged_units_expenses_per_total_area_not_exchanged|
      # Formula: exchanged_units_expenses / total_area_not_exchanged
      it "calculates the exchanged units expenses per total area not exchanged" do
        project = FactoryGirl.build(:project)
        allow(project).to receive(:total_area_not_exchanged).and_return(total_area_not_exchanged)
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis, project: project)
        allow(sensitivity_analysis).to receive(:exchanged_units_expenses).and_return(exchanged_units_expenses)

        expect(sensitivity_analysis.exchanged_units_expenses_per_total_area_not_exchanged).to eq(exchanged_units_expenses_per_total_area_not_exchanged)
      end
    end
  end

  describe "#total_exchanged_units_costs" do
    [ # exchanged_units_construction_costs | exchanged_units_expenses | total_exchanged_units_costs
      [                           2000.00,                   1000.00,                      3000.00 ],
      [                           2123.45,                   1234.23,                      3357.68 ]
    ].each do |exchanged_units_construction_costs, exchanged_units_expenses, total_exchanged_units_costs|
      # Formula: exchanged_units_construction_costs + exchanged_units_expenses
      it "calculates the total exchanged units costs" do
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis)
        allow(sensitivity_analysis).to receive(:exchanged_units_construction_costs).and_return(exchanged_units_construction_costs)
        allow(sensitivity_analysis).to receive(:exchanged_units_expenses).and_return(exchanged_units_expenses)

        expect(sensitivity_analysis.total_exchanged_units_costs).to eq(total_exchanged_units_costs)
      end
    end
  end

  describe "#total_construction_and_sales_costs" do
    [ # construction_costs |    individualization_costs | land_acquisition_cost | sales_commissions | sales_taxes | sales_charges | exchanged_units_expenses | total_construction_and_sales_costs
      [            1000.00,                     1000.00,                1000.00,            1000.00,      1000.00,        1000.00,                   1000.00,                             7000.00 ]
    ].each do |construction_costs, individualization_costs, land_acquisition_cost, sales_commissions, sales_taxes, sales_charges, exchanged_units_expenses, total_construction_and_sales_costs|
      # Formula: construction_costs + individualization_costs + land_acquisition_cost + sales_commissions + sales_taxes + sales_charges + exchanged_units_expenses
      it "calculates the total construction and sales costs" do
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis, individualization_costs: individualization_costs,
                                                                        land_acquisition_cost: land_acquisition_cost,
                                                                        exchanged_units_expenses: exchanged_units_expenses)
        allow(sensitivity_analysis).to receive(:construction_costs).and_return(construction_costs)
        allow(sensitivity_analysis).to receive(:sales_commissions).and_return(sales_commissions)
        allow(sensitivity_analysis).to receive(:sales_taxes).and_return(sales_taxes)
        allow(sensitivity_analysis).to receive(:sales_charges).and_return(sales_charges)

        expect(sensitivity_analysis.total_construction_and_sales_costs).to eq(total_construction_and_sales_costs)
      end
    end
  end

    describe "#markup" do
    [ # selling_price | sales_taxes_rate | sales_charges_rate | net_profit_margin |  markup
      [          6.00,              5.93,                3.00,              15.00,  1.42714 ],
      [          4.00,              5.93,                5.00,              17.00,  1.46908 ],
      [          0.00,              0.00,                0.00,               0.00,     1.00 ],
      [           nil,               nil,                 nil,                nil,     1.00 ]
    ].each do |sales_commissions_rate, sales_taxes_rate, sales_charges_rate, net_profit_margin, markup|
      # Formula: 100 / (100 - sales_commissions_rate - sales_taxes_rate - sales_charges_rate - net_profit_margin)
      it "calculates the markup" do
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis, project: project,
                                                                        sales_commissions_rate: sales_commissions_rate,
                                                                        sales_taxes_rate: sales_taxes_rate,
                                                                        sales_charges_rate: sales_charges_rate,
                                                                        net_profit_margin: net_profit_margin)

        expect(sensitivity_analysis.markup).to eq(markup)
      end
    end
  end

  describe "#expected_result" do
    [ # net_profit_margin | expected_revenue | expected_result
      [             10.00,           1000.00,           100.00 ],
      [              7.56,           3500.23,           264.62 ]
    ].each do |net_profit_margin, expected_revenue, expected_result|
      # Formula: expected_revenue * (net_profit_margin / 100)
      it "calculates the expected result" do
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis, net_profit_margin: net_profit_margin)
        allow(sensitivity_analysis).to receive(:expected_revenue).and_return(expected_revenue)

        expect(sensitivity_analysis.expected_result).to eq(expected_result)
      end
    end
  end

  describe "#result" do
    [ # unit_one_result | unit_two_result | unit_three_result |  result
      [          100.00,           100.00,             100.00,   300.00 ],
      [         1234.56,          3500.23,               0.00,  4734.79 ],
      [         2400.21,          3500.20,            2222.22,  8122.63 ]
    ].each do |unit_one_result, unit_two_result, unit_three_result, result|
      # Formula: sum all units result
      it "calculates the result" do
        unit_one_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_one_sensitivity_analysis).to receive(:result).and_return(unit_one_result)
        unit_two_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_two_sensitivity_analysis).to receive(:result).and_return(unit_two_result)
        unit_three_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_three_sensitivity_analysis).to receive(:result).and_return(unit_three_result)
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis)
        sensitivity_analysis.unit_sensitivity_analyses << unit_one_sensitivity_analysis
        sensitivity_analysis.unit_sensitivity_analyses << unit_two_sensitivity_analysis
        sensitivity_analysis.unit_sensitivity_analyses << unit_three_sensitivity_analysis

        expect(sensitivity_analysis.result).to eq(result)
      end
    end
  end

  describe "#average_profit_rate" do
    [ # unit_one_profit_rate | unit_two_profit_rate | unit_three_profit_rate |  average_profit_rate
      [                10.00,                 10.00,                   10.00,                 10.00 ],
      [                10.00,                 10.00,                    0.00,                  6.67 ],
      [                 8.23,                 -3.12,                    6.45,                  3.85 ],
    ].each do |unit_one_profit_rate, unit_two_profit_rate, unit_three_profit_rate, average_profit_rate|
      # Formula: sum all units profit rate where profit rate not 0
      it "calculates the average profit rate" do
        unit_one_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_one_sensitivity_analysis).to receive(:profit_rate).and_return(unit_one_profit_rate)
        unit_two_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_two_sensitivity_analysis).to receive(:profit_rate).and_return(unit_two_profit_rate)
        unit_three_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_three_sensitivity_analysis).to receive(:profit_rate).and_return(unit_three_profit_rate)
        project = FactoryGirl.build(:project)
        allow(project).to receive(:total_units_not_exchanged).and_return(3)
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis, project: project)
        sensitivity_analysis.unit_sensitivity_analyses << unit_one_sensitivity_analysis
        sensitivity_analysis.unit_sensitivity_analyses << unit_two_sensitivity_analysis
        sensitivity_analysis.unit_sensitivity_analyses << unit_three_sensitivity_analysis

        expect(sensitivity_analysis.average_profit_rate).to eq(average_profit_rate)
      end
    end
  end

  describe "#completed" do
    context "when is not completed" do
      [ #   name | net_profit_margin | cost_per_square_meter | completed_units | uncompleted_units
        [     "",                 "",                     "",                0,                  0 ],
        [     "",                 10,                   1000,                2,                  0 ],
        [ "Name",                 "",                   1000,                2,                  0 ],
        [ "Name",                 10,                     "",                2,                  0 ],
        [ "Name",                 10,                   1000,                2,                  2 ],
      ].each do |name, net_profit_margin, cost_per_square_meter, completed_units, uncompleted_units|
        it "returns false" do
          sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis)
          sensitivity_analysis.name = name
          sensitivity_analysis.net_profit_margin = net_profit_margin
          sensitivity_analysis.sales_commissions_rate = ""
          sensitivity_analysis.sales_taxes_rate = ""
          sensitivity_analysis.sales_charges_rate = ""
          sensitivity_analysis.individualization_costs = ""
          sensitivity_analysis.cost_per_square_meter = cost_per_square_meter
          sensitivity_analysis.land_acquisition_cost = ""
          sensitivity_analysis.exchanged_units_expenses = ""

          completed_units.times do
            unit_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
            allow(unit_sensitivity_analysis).to receive(:completed).and_return(true)
            sensitivity_analysis.unit_sensitivity_analyses << unit_sensitivity_analysis
          end

          uncompleted_units.times do
            unit_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
            allow(unit_sensitivity_analysis).to receive(:completed).and_return(false)
            sensitivity_analysis.unit_sensitivity_analyses << unit_sensitivity_analysis
          end

          expect(sensitivity_analysis.completed).to be(false)
        end
      end
    end

    context "when is completed" do
      it "returns true" do
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis)
        sensitivity_analysis.name = "Sensitivity Analysis Example"
        sensitivity_analysis.net_profit_margin = 10
        sensitivity_analysis.sales_commissions_rate = ""
        sensitivity_analysis.sales_taxes_rate = ""
        sensitivity_analysis.sales_charges_rate = ""
        sensitivity_analysis.individualization_costs = ""
        sensitivity_analysis.cost_per_square_meter = 1000
        sensitivity_analysis.land_acquisition_cost = ""
        sensitivity_analysis.exchanged_units_expenses = ""
        unit_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis)
        allow(unit_sensitivity_analysis).to receive(:completed).and_return(true)
        sensitivity_analysis.unit_sensitivity_analyses << unit_sensitivity_analysis

        expect(sensitivity_analysis.completed).to be(true)
      end
    end
  end
end