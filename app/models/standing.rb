class Standing < ActiveRecord::Base
  belongs_to :match_week
  belongs_to :user
end
