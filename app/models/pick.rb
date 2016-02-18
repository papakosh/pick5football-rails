class Pick < ActiveRecord::Base
  belongs_to :User
  belongs_to :MatchWeek
end
