class AddUrlTypeToReference < ActiveRecord::Migration
  def change
    add_column :references, :url_type, :string
  end
end
