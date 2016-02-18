class PicksController < ApplicationController

	def index
		@year = session["year"]
		associated_user = User.find_by(user_id: session["user_id"])
		match_weeks = MatchWeek.where(year: @year)
		user_picks = Pick.where(user_id: associated_user.id).order(match_week_id: :asc)
		@pickDisplayDataArray = []
		index = 0
		match_weeks.each do |match_week|
			if user_picks.length != index && match_week.id == user_picks[index].match_week_id
				tempPick = PicksDisplayData.new(match_week.week, user_picks[index].teams, user_picks[index].id, user_picks[index].match_week_id)
				if user_picks[index].submitted == false
					tempPick.edit_link = true
					tempPick.delete_link = true
					tempPick.new_link = false
					tempPick.submit_link = true
				else
					tempPick.edit_link = false
					tempPick.delete_link = false
					tempPick.new_link = false
					tempPick.submit_link = false
					tempPick.submitted = true
				end
				@pickDisplayDataArray << tempPick
				index+=1
			else
				tempPick = PicksDisplayData.new(match_week.week, "", 0, match_week.id)
				@pickDisplayDataArray << tempPick
			end
		end
	end

	def new
		match_week = MatchWeek.find_by(id: params[:match_week_id])
		matches = Match.where(match_week_id: match_week.id).order(id: :asc)
		@pickSelectionArray = []
			
		matches.each do |match|
			pickSelection = PickSelectionData.new(match.team1, match.team2, match.week)
			@pickSelectionArray << pickSelection
		end
	end

	def create
		action = params[:commit]
		associated_user = User.find_by(user_id: session["user_id"])
		if action == 'Cancel'
			redirect_to controller: 'picks'
		elsif action == 'Save'
			match_week = MatchWeek.find_by(id: params[:match_week_id])
			index = 0;
			teams = ""
			while index < 16 do
				pick = params["match_#{index}"]
				if pick.present? && pick != 'None'
					teams = teams + pick + ";"
				end
				index+=1
			end
			if teams != ""
				Pick.create(teams: teams, submitted: false, user_id: associated_user.id, match_week_id: match_week.id)
			end
			redirect_to controller: 'picks'
		end
	end

	def edit
		user_picks = Pick.find_by(id: params[:id])
		teamSelectionArray = user_picks.teams.split(';')
		match_weeks = MatchWeek.find_by(id: user_picks.match_week_id)
		matches = Match.where(match_week_id: match_weeks.id).order(id: :asc)
		@pickSelectionArray = []
			
		matches.each do |match|
			pickSelection = nil
			if teamSelectionArray.include? match.team1
				pickSelection = match.team1
			elsif teamSelectionArray.include? match.team2
				pickSelection = match.team2
			end
			tempPick = PickSelectionData.new(match.team1, match.team2, match.week, pickSelection)
			@pickSelectionArray << tempPick
		end
	end

	def update
		action = params[:commit]
		if action == 'Cancel'
			redirect_to controller: 'picks'
		elsif action == 'Save'
			user_picks = Pick.find_by(id: params[:id])
			index = 0;
			teams = ""
			while index < 16 do
				pick = params["match_#{index}"]
				if pick.present? && pick != 'None'
					teams = teams + pick + ";"
				end
				index+=1
			end
			user_picks.teams = teams
			user_picks.save			
			redirect_to controller: 'picks'
		end
	end

	def destroy
		picks=Pick.find(params[:id])
		picks.destroy
		redirect_to controller: 'picks'
	end

	def submit_picks
		picks = Pick.find_by(id: params[:pick_id])
		#todo validation to make sure only 5 picks exist
		picks.submitted = true
		picks.save
		redirect_to controller: 'picks'
	end

	def show
		@users = User.all.order(id: :asc)
		@match_weeks = MatchWeek.where(year: session["year"]).order(id: :asc)
		#puts "number of match weeks = #{@match_weeks.length}"
		@submittedPicksArray = []
		@match_weeks.each do |match_week|
			userPicksArray = []
			@users.each do |user|
				weekly_picks = Pick.find_by(match_week_id: match_week.id, user_id: user.id)
				if weekly_picks.present?
					userPick = UserPick.new(user.id, weekly_picks.id, weekly_picks.submitted)
				else
					userPick = UserPick.new(user.id)
				end
				userPicksArray << userPick
			end
			submittedPicks = SubmittedPicks.new(match_week.week, userPicksArray)
			@submittedPicksArray << submittedPicks
		end
	end
end

class PickSelectionData
  	include ActiveModel::Conversion
  	extend  ActiveModel::Naming
  	attr_reader :team1, :team2, :week, :selection
  	def persisted?
    	false
  	end
	def initialize(team1, team2, week, selection=nil)
		@team1 = team1
		@team2 = team2
		@week = week
		@selection = selection
	end

	def team1_logo
		return @team1.downcase.gsub! ' ','_'
	end

	def team2_logo
		return @team2.downcase.gsub! ' ','_'
	end
end

class PicksDisplayData
	include ActiveModel::Conversion
  	extend  ActiveModel::Naming
  	attr_reader :match_week_name, :teams, :edit_link, :new_link, :delete_link, :submit_link, :match_week_id, :pick_id, :submitted
  	attr_writer :edit_link, :new_link, :delete_link, :submit_link, :submitted
  	def persisted?
    	false
  	end
	def initialize(match_week_name, teams, pick_id, match_week_id)
		@match_week_name = match_week_name
		@teams = teams
		@edit_link = false
		@new_link = true
		@delete_link = false
		@submit_link = false
		@pick_id = pick_id
		@match_week_id = match_week_id
		@submitted = false
	end
end

class SubmittedPicks
	include ActiveModel::Conversion
	extend ActiveModel::Naming
	attr_reader :userPicksSubmitted, :week
	attr_writer :userPicksSubmitted, :week
	def persisted?
		false
	end

	def initialize(week, userPicksSubmitted)
		@userPicksSubmitted = userPicksSubmitted
		@week = week
	end
end

class UserPick
	include ActiveModel::Conversion
	extend ActiveModel::Naming
	attr_reader :submitted
	attr_writer :submitted

	def persisted?
		false
	end

	def initialize(user_id, pick_id=nil, submitted=false)
		@user_id=user_id
		@pick_id = pick_id
		@submitted=submitted
	end
end