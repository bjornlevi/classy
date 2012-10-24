class AddFeaturesCount < ActiveRecord::Migration
  def up
  	add_column :posts, :features_count, :integer, default: 0

  	Post.reset_column_information
  	Post.all.each do |p|
  		Post.reset_counters p.id, :features
  	end
  end

  def down
  	remove_column :posts, :features_count
  end
end
