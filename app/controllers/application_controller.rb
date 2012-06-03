class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include GroupsHelper

  before_filter :user_groups
end
