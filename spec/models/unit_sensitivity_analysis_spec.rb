require 'spec_helper'
require 'rails_helper'

describe UnitSensitivityAnalysis do
  subject(:unit_sensitivity_analysis) { FactoryGirl.build(:unit_sensitivity_analysis) }

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
  it { expect(subject).to respond_to(:result) }
  it { expect(subject).to respond_to(:profit_rate) }
  it { expect(subject).to respond_to(:unit_id) }
  it { expect(subject).to respond_to(:sensitivity_analysis_id) }

  it { expect(subject).to belong_to(:unit) }
  it { expect(subject).to belong_to(:sensitivity_analysis) }

  it { expect(subject).to validate_presence_of(:unit) }
  it { expect(subject).to validate_presence_of(:sensitivity_analysis) }

  describe "#selling_price" do
    [ # individualization_costs | construction_costs | land_acquisition_cost | exchanged_units_construction_costs | exchanged_units_expenses | markup | exchanged | selling_price
      [                  100.00,              100.00,                 100.00,                              100.00,                    100.00,   15.00,      false,        7500.00 ],
      [                  213.21,              221.10,                 121.00,                              133.20,                    101.01,   12.00,      false,        9474.24 ],
      [                  213.21,              221.10,                 121.00,                              133.20,                    101.01,   12.00,      true,            0.00 ]
    ].each do |individualization_costs, construction_costs, land_acquisition_cost, exchanged_units_construction_costs, exchanged_units_expenses, markup, exchanged, selling_price|
      # Formula: (individualization_costs + construction_costs + land_acquisition_cost +
      #           exchanged_units_construction_costs + exchanged_units_expenses) * markup
      it "calculates the selling price" do
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis)
        allow(sensitivity_analysis).to receive(:markup).and_return(markup)
        unit = FactoryGirl.build(:unit, exchanged: exchanged)
        unit_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis, sensitivity_analysis: sensitivity_analysis,
                                                                                  unit: unit)
        allow(unit_sensitivity_analysis).to receive(:individualization_costs).and_return(individualization_costs)
        allow(unit_sensitivity_analysis).to receive(:construction_costs).and_return(construction_costs)
        allow(unit_sensitivity_analysis).to receive(:land_acquisition_cost).and_return(land_acquisition_cost)
        allow(unit_sensitivity_analysis).to receive(:exchanged_units_construction_costs).and_return(exchanged_units_construction_costs)
        allow(unit_sensitivity_analysis).to receive(:exchanged_units_expenses).and_return(exchanged_units_expenses)

        expect(unit_sensitivity_analysis.selling_price).to eq(selling_price)
      end
    end
  end

  describe "#sales_commissions" do
    [ # sale_price | sales_commissions_rate | exchanged | sales_commissions
      [   10000.00,                       6,      false,            600.00 ],
      [   12345.67,                       6,      false,            740.74 ],
      [   30400.29,                    7.54,      false,           2292.18 ],
      [   30400.29,                    7.54,       true,              0.00 ]
    ].each do |sale_price, sales_commissions_rate, exchanged, sales_commissions|
      # Formula: (sale_price * (sales_commissions_rate / 100)
      it "calculates the sales commissions" do
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis, sales_commissions_rate: sales_commissions_rate)
        unit = FactoryGirl.build(:unit, exchanged: exchanged)
        unit_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis, sensitivity_analysis: sensitivity_analysis,
                                                                                  unit: unit,
                                                                                  sale_price: sale_price)

        expect(unit_sensitivity_analysis.sales_commissions).to eq(sales_commissions)
      end
    end
  end

  describe "#sales_taxes" do
    [ # sale_price | sales_taxes_rate | exchanged | sales_taxes
      [   10000.00,              5.93,      false,       593.00 ],
      [   12345.67,              5.93,      false,       732.10 ],
      [   30400.29,              7.54,      false,      2292.18 ],
      [   30400.29,              7.54,       true,         0.00 ]
    ].each do |sale_price, sales_taxes_rate, exchanged, sales_taxes|
      # Formula: (sale_price * (sales_taxes_rate / 100)
      it "calculates the sales taxes" do
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis, sales_taxes_rate: sales_taxes_rate)
        unit = FactoryGirl.build(:unit, exchanged: exchanged)
        unit_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis, sensitivity_analysis: sensitivity_analysis,
                                                                                  unit: unit,
                                                                                  sale_price: sale_price)

        expect(unit_sensitivity_analysis.sales_taxes).to eq(sales_taxes)
      end
    end
  end

  describe "#sales_charges" do
    [ # sale_price | sales_charges_rate | exchanged | sales_charges
      [   10000.00,                   3,      false,         300.00 ],
      [   12345.67,                   3,      false,         370.37 ],
      [   30400.29,                4.53,      false,        1377.13 ],
      [   30400.29,                4.53,       true,           0.00 ]
    ].each do |sale_price, sales_charges_rate, exchanged, sales_charges|
      # Formula: (sale_price * (sales_charges_rate / 100)
      it "calculates the sales charges" do
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis, sales_charges_rate: sales_charges_rate)
        unit = FactoryGirl.build(:unit, exchanged: exchanged)
        unit_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis, sensitivity_analysis: sensitivity_analysis,
                                                                                  unit: unit,
                                                                                  sale_price: sale_price)

        expect(unit_sensitivity_analysis.sales_charges).to eq(sales_charges)
      end
    end
  end

  describe "#individualization_costs" do
    [ # total_individualization_costs | total_units_not_exchanged | exchanged | individualization_costs
      [                      10000.00,                         20,       true,                      0.00 ],
      [                      10000.00,                         20,      false,                    500.00 ],
      [                      21234.12,                         25,       true,                      0.00 ],
      [                      21234.12,                         25,      false,                    849.36 ],
    ].each do |total_individualization_costs, total_units_not_exchanged, exchanged, individualization_costs|
      # Formula: total_individualization_costs / total_units_not_exchanged
      it "calculates the individualization costs for not exchanged units" do
        project = FactoryGirl.create(:project)
        allow(project).to receive(:total_units_not_exchanged).and_return(total_units_not_exchanged)
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis, project: project)
        allow(sensitivity_analysis).to receive(:individualization_costs).and_return(total_individualization_costs)
        unit = FactoryGirl.build(:unit, exchanged: exchanged)
        unit_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis, sensitivity_analysis: sensitivity_analysis, unit: unit)

        expect(unit_sensitivity_analysis.individualization_costs).to eq(individualization_costs)
      end
    end
  end

  describe "#land_acquisition_cost" do
    [ # land_acquisition_cost_per_total_area_not_exchanged | total_area | exchanged | land_acquisition_cost
      [                                              75.41,      115.05,      false,                8675.92 ],
      [                                              75.41,      115.05,       true,                   0.00 ],
      [                                             102.23,      210.23,      false,               21491.81 ]
    ].each do |land_acquisition_cost_per_total_area_not_exchanged, total_area, exchanged, land_acquisition_cost|
      # Formula: sensitivity_analysis.land_acquisition_cost_per_total_area_not_exchanged * unit.total_area
      it "calculates the land acquisition cost" do
        unit = FactoryGirl.build(:unit, exchanged: exchanged)
        allow(unit).to receive(:total_area).and_return(total_area)
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis)
        allow(sensitivity_analysis).to receive(:land_acquisition_cost_per_total_area_not_exchanged).and_return(land_acquisition_cost_per_total_area_not_exchanged)
        unit_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis, sensitivity_analysis: sensitivity_analysis, unit: unit)

        expect(unit_sensitivity_analysis.land_acquisition_cost).to eq(land_acquisition_cost)
      end
    end
  end

  describe "#construction_costs" do
    [ # cost_per_square_meter | private_area | common_area | box_area |  construction_costs
      [               1050.00,        381.43,       200.21,      0.00,            610722.00 ],
      [               1050.00,         74.05,        41.71,     10.81,            132898.50 ],
      [               1520.00,        381.43,       200.21,      0.00,            884092.80 ],
      [               1520.00,         74.05,        41.71,     10.81,            192386.40 ]
    ].each do |cost_per_square_meter, private_area, common_area, box_area, construction_costs|
      # Formula: sensitivity_analysis.cost_per_square_meter * unit.total_area
      it "calculates the construction costs" do
        sensitivity_analysis = FactoryGirl.create(:sensitivity_analysis, cost_per_square_meter: cost_per_square_meter)
        unit = FactoryGirl.create(:unit, private_area: private_area,
                                         common_area: common_area,
                                         box_area: box_area)
        unit_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis, sensitivity_analysis: sensitivity_analysis,
                                                                                  unit: unit)

        expect(unit_sensitivity_analysis.construction_costs).to eq(construction_costs)
      end
    end
  end

  describe "#exchanged_units_construction_costs" do
    [ # total_area | exchanged_units_construction_costs_per_total_area_not_exchanged | exchanged | exchanged_units_construction_costs
      [     115.05,                                                           257.40,      false,                            29613.87 ],
      [     114.33,                                                           212.19,       true,                                0.00 ],
      [     120.13,                                                           142.89,      false,                            17165.38 ]
    ].each do |total_area, exchanged_units_construction_costs_per_total_area_not_exchanged, exchanged, exchanged_units_construction_costs|
      # Formula: total_area * exchanged_units_construction_costs_per_total_area_not_exchanged
      it "calculates the exchanged units construction costs" do
        unit = FactoryGirl.build(:unit, exchanged: exchanged)
        allow(unit).to receive(:total_area).and_return(total_area)
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis)
        allow(sensitivity_analysis).to receive(:exchanged_units_construction_costs_per_total_area_not_exchanged).and_return(exchanged_units_construction_costs_per_total_area_not_exchanged)
        unit_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis, sensitivity_analysis: sensitivity_analysis, unit: unit)

        expect(unit_sensitivity_analysis.exchanged_units_construction_costs).to eq(exchanged_units_construction_costs)
      end
    end
  end

  describe "#exchanged_units_expenses" do
    [ # total_area | exchanged_units_expenses_per_total_area_not_exchanged | exchanged | exchanged_units_expenses
      [     115.05,                                                 257.40,      false,                  29613.87 ],
      [     114.33,                                                 212.19,       true,                      0.00 ],
      [     120.13,                                                 142.89,      false,                  17165.38 ]
    ].each do |total_area, exchanged_units_expenses_per_total_area_not_exchanged, exchanged, exchanged_units_expenses|
      # Formula: total_area * exchanged_units_expenses_per_total_area_not_exchanged
      it "calculates the exchanged units expenses" do
        unit = FactoryGirl.build(:unit, exchanged: exchanged)
        allow(unit).to receive(:total_area).and_return(total_area)
        sensitivity_analysis = FactoryGirl.build(:sensitivity_analysis)
        allow(sensitivity_analysis).to receive(:exchanged_units_expenses_per_total_area_not_exchanged).and_return(exchanged_units_expenses_per_total_area_not_exchanged)
        unit_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis, sensitivity_analysis: sensitivity_analysis, unit: unit)

        expect(unit_sensitivity_analysis.exchanged_units_expenses).to eq(exchanged_units_expenses)
      end
    end
  end

  describe "#result" do
    [ # sale_price | individualization_costs | construction_costs | land_acquisition_cost | exchanged_units_construction_costs | exchanged_units_expenses | sales_commissions | sales_taxes | sales_charges | exchanged |   result
      [   10000.00,                  1000.00,             1000.00,                1000.00,                             1000.00,                   1000.00,            1000.00,      1000.00,        1000.00,      false,   2000.00 ],
      [   20200.12,                  1013.30,             2000.00,                1000.00,                                0.00,                      0.00,            1023.23,         0.00,        1000.00,      false,  14163.59 ],
      [   10000.00,                  1000.00,             1000.00,                1000.00,                             1000.00,                   1000.00,            1000.00,      1000.00,        1000.00,       true,      0.00 ]
    ].each do |sale_price, individualization_costs, construction_costs, land_acquisition_cost, exchanged_units_construction_costs, exchanged_units_expenses, sales_commissions, sales_taxes, sales_charges, exchanged, result|
      # Formula: sale_price - individualization_costs - construction_costs -
      #          land_acquisition_cost - exchanged_units_construction_costs - exchanged_units_expenses
      #          sales_commissions - sales_taxes - sales_charges
      it "calculates the result" do
        unit = FactoryGirl.build(:unit, exchanged: exchanged)
        unit_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis, unit: unit,
                                                                                  sale_price: sale_price)
        allow(unit_sensitivity_analysis).to receive(:individualization_costs).and_return(individualization_costs)
        allow(unit_sensitivity_analysis).to receive(:construction_costs).and_return(construction_costs)
        allow(unit_sensitivity_analysis).to receive(:land_acquisition_cost).and_return(land_acquisition_cost)
        allow(unit_sensitivity_analysis).to receive(:exchanged_units_construction_costs).and_return(exchanged_units_construction_costs)
        allow(unit_sensitivity_analysis).to receive(:exchanged_units_expenses).and_return(exchanged_units_expenses)
        allow(unit_sensitivity_analysis).to receive(:sales_commissions).and_return(sales_commissions)
        allow(unit_sensitivity_analysis).to receive(:sales_taxes).and_return(sales_taxes)
        allow(unit_sensitivity_analysis).to receive(:sales_charges).and_return(sales_charges)

        expect(unit_sensitivity_analysis.result).to eq(result)
      end
    end
  end

  describe "#profit_rate" do
    [ # sale_price | result | exchanged | profit_rate
      [    1000.00,  100.00,      false,        10.00 ],
      [    2420.12,  234.56,      false,        9.69 ],
      [    2420.12,  234.56,       true,        0.00 ],
    ].each do |sale_price, result, exchanged, profit_rate|
      # Formula: (result / sale_price) * 100
      it "calculates the profit rate" do
        unit = FactoryGirl.build(:unit, exchanged: exchanged)
        unit_sensitivity_analysis = FactoryGirl.build(:unit_sensitivity_analysis, unit: unit,
                                                                                  sale_price: sale_price)
        allow(unit_sensitivity_analysis).to receive(:result).and_return(result)

        expect(unit_sensitivity_analysis.profit_rate).to eq(profit_rate)
      end
    end
  end
end