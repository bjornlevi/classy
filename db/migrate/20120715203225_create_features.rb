class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end
  end
end
