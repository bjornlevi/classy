class AddUrlToReference < ActiveRecord::Migration
  def change
    add_column :references, :url, :string
  end
end
