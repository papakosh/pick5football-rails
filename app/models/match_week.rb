class MatchWeek < ActiveRecord::Base
	has_many :matches, dependent: :destroy
	has_many :picks, dependent: :destroy	
end
