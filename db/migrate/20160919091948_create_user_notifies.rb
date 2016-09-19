class CreateUserNotifies < ActiveRecord::Migration
  def change
    create_table :user_notifies do |t|
      t.integer :user_id
      t.string :currency
      t.float :target_amount
      t.datetime :created_at
      t.boolean :is_enabled, default: true

      t.timestamps null: false
    end
  end
end
