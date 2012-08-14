class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include GroupsHelper

  before_filter :user_groups

  after_filter :activity_log

private

	def activity_log
		if current_user
			Activity.create!(user_id: current_user.id, path: request.fullpath, params: params.to_s, ip: request.remote_ip)
		else
			Activity.create!(user_id: nil, path: request.fullpath, params: params.to_s, ip: request.remote_ip)
		end
	end
end
