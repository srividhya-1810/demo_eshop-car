class CreateCars < ActiveRecord::Migration[7.0]
  def change
    create_table :cars do |t|
      t.string :brand
      t.integer :price
      t.integer :car_type 
      t.integer :fuel_type
      t.integer :condition
      t.string :color 
      t.integer :status

      t.timestamps
    end
  end
end
