class UserProfile < ActiveRecord::Base
  attr_accessible :description, :first_name, :last_name

  belongs_to :user

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :description, presence: true

end
