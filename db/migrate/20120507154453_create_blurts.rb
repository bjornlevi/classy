class CreateBlurts < ActiveRecord::Migration
  def change
    create_table :blurts do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :blurts, [:user_id, :created_at]
  end
end
