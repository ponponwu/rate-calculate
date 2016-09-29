class CreateAttentions < ActiveRecord::Migration
  def change
    create_table :attentions do |t|
      t.integer :user_id
      t.string :currency
      t.float :target_amount
      t.boolean :is_enabled, default: true

      t.timestamps null: false
    end
  end
end
