class Activity < ActiveRecord::Base
  belongs_to :user
  attr_accessible :user_id, :params, :path, :ip
end
