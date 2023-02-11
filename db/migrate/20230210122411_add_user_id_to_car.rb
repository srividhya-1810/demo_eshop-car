class AddUserIdToCar < ActiveRecord::Migration[7.0]
  def change
    add_column :cars, :user_id, :int
  end
end
