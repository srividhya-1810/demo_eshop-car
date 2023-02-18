class AddCommentColumn < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :comment , :string
  end
end
