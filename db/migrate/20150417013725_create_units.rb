class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.belongs_to :project

      t.string  :name
      t.decimal :private_area
      t.decimal :common_area
      t.decimal :box_area
      t.boolean :exchanged

      t.timestamps null: false
    end
  end
end
