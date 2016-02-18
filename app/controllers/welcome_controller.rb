class WelcomeController < ApplicationController
	before_filter :authenticate
  def index
    user_id = session["user_id"]
    user = User.where(user_id: user_id).first
    @name, _ = user.name.split(' ')
    @user_type = user.user_type
  end

  def authenticate
  	puts 'authenticate....'
  	authenticate_or_request_with_http_basic do |user_id|
  		if User.authenticate(user_id).present?
        session["user_id"] = user_id
        session["year"] = "2015"
        return true
  	end
  end
end
