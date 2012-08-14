class AddIpToActivity < ActiveRecord::Migration
  def change
    add_column :activities, :ip, :string
  end
end
