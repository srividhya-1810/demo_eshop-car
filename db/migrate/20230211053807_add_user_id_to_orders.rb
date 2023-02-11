class AddUserIdToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :user_id , :int
    add_column :orders, :car_id , :int
  end
end
