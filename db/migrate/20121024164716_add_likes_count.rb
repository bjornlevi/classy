class AddLikesCount < ActiveRecord::Migration
  def up
  	add_column :posts, :likes_count, :integer, default: 0

  	Post.reset_column_information
  	Post.all.each do |p|
  		Post.reset_counters p.id, :likes
  	end
  end

  def down
  	remove_column :posts, :likes_count
  end
end
