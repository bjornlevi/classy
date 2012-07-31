class CreateReads < ActiveRecord::Migration
  def change
    create_table :reads do |t|
      t.references :user
      t.references :post

      t.timestamps
    end
    add_index :reads, :user_id
    add_index :reads, :post_id
  end
end
