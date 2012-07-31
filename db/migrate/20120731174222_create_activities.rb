class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :user
      t.string :path
      t.text :params

      t.timestamps
    end
    add_index :activities, :user_id
  end
end
