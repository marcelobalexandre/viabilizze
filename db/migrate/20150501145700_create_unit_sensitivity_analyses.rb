class CreateUnitSensitivityAnalyses < ActiveRecord::Migration
  def change
    create_table :unit_sensitivity_analyses do |t|
      t.belongs_to :unit
      t.belongs_to :sensitivity_analysis

      t.decimal :sale_price

      t.timestamps null: false
    end
  end
end
