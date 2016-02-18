class StandingsController < ApplicationController
	def index
		@users = User.all.order(id: :asc)
		match_weeks = MatchWeek.where(year: session["year"]).order(id: :asc)
		#@standings = Standing.where(year: session["year"])
		@weeklyStandingsArray = []
		@userTotals = Array[0,0,0]
		match_weeks.each do |match_week|
			userNum = 0
			userStandingsArray = []
			@users.each do |user|
				standings = Standing.find_by(match_week_id: match_week.id, user_id: user.id)
				if standings.present?
					userStanding = UserStanding.new(user.id, standings.wins)
					@userTotals[userNum] = @userTotals[userNum] + standings.wins
				else
					userStanding = UserStanding.new(user.id, 0)
					@userTotals[userNum] = @userTotals[userNum] + 0
				end
				userStandingsArray << userStanding
				userNum+=1
			end
			weeklyStandings = WeeklyStandings.new(match_week.week, userStandingsArray)
			@weeklyStandingsArray  << weeklyStandings
		end
	end
end

class WeeklyStandings
	include ActiveModel::Conversion
	extend ActiveModel::Naming
	attr_reader :week, :userStandings
	attr_writer :week, :userStandings
	def persisted?
		false
	end

	def initialize(week, userStandings)
		@week = week
		@userStandings = userStandings
	end
end

class UserStanding
	include ActiveModel::Conversion
	extend ActiveModel::Naming
	attr_reader :user_id, :wins
	attr_writer :user_id, :wins
	def persisted?
		false
	end

	def initialize(user_id, wins)
		@user_id = user_id
		@wins = wins
	end
end

