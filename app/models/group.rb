class Group < ActiveRecord::Base
  attr_accessible :description, :name, :status, :user_id
end
