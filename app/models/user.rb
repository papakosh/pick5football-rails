class User < ActiveRecord::Base
	def self.authenticate(user_id)
		user = User.where(user_id: user_id).first
	end


end
