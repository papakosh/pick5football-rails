class MatchWeek < ActiveRecord::Base
	has_many :matches, dependent: :destroy
end
