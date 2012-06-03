class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.integer :user_id
      t.string :status

      t.timestamps
    end
    add_index :groups, :name, :unique => true
  end
end
