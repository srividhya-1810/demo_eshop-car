class WishList < ActiveRecord::Migration[7.0]
  def change
    create_table :wishes do |t|
      t.integer :car_id
      t.integer :user_id
    end
  end
end
