class CreateSensitivityAnalyses < ActiveRecord::Migration
  def change
    create_table :sensitivity_analyses do |t|
      t.belongs_to :project

      t.string  :name
      t.decimal :net_profit_margin
      t.decimal :sales_commissions_rate
      t.decimal :sales_taxes_rate
      t.decimal :sales_charges_rate
      t.decimal :individualization_costs
      t.decimal :cost_per_square_meter
      t.decimal :land_acquisition_cost
      t.decimal :exchanged_units_expenses

      t.timestamps null: false
    end
  end
end
