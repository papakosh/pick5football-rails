class MatchWeeksController < ApplicationController
	def index
		@match_weeks = MatchWeek.all
	end

	def show
		#@matches = Match.where(year: "2015", week: "2")
	end

	def new
		@year = session["year"]
		@matchEntryArray = []
		index = 0
		while index < 16 do
			matchEntry = MatchEntryData.new
			@matchEntryArray << matchEntry
			index+=1
		end
	end

	def create
		weekSelected = params["week"]
		yearSelected = params["year"]
		action = params[:commit]		
		matchNum = 0
		if action == 'Cancel'
			redirect_to controller: 'match_weeks' and return
		elsif action == 'Save'
			#todo validate to prevent same week from being entered
			match_week = MatchWeek.create(year: yearSelected, week: weekSelected)
			while matchNum < 16 do
				team1Selected = params["match#{matchNum}_team1"]
				team2Selected = params["match#{matchNum}_team2"]
				homeTeam = params["match#{matchNum}_hometeam"]
				spread = params["match#{matchNum}_spread"]
				favoredTeam = params["match#{matchNum}_favoredteam"]
				date = params["match#{matchNum}_date"]
				time = params["match#{matchNum}_time"]
			
				if team1Selected.present? && team2Selected.present? &&
					homeTeam.present? && spread.present? && favoredTeam.present? && 
					date.present? && time.present?
			
					match_week.matches.create(year: yearSelected, week: weekSelected, match_num: matchNum, team1: team1Selected, team2: team2Selected, 
												home_team: homeTeam, spread: spread, favored_team: favoredTeam, date: date, time: time)
			
				end
				matchNum+= 1

			end
			redirect_to controller: 'match_weeks'
		end
	end

	def edit
		matchweekid = params[:id]
		puts "match week id = #{matchweekid}"
		match_week = MatchWeek.find(params[:id])
		matches = Match.where(match_week_id: params[:id]).order(id: :asc)
		@year = match_week.year
		@week = match_week.week
		@matchEntryArray = []
		index = 0
		while index < 16 do
			if matches[index].present?
				matchEntry = MatchEntryData.new(matches[index].team1, matches[index].team2, matches[index].home_team, matches[index].favored_team, 
												matches[index].spread, matches[index].date, matches[index].time)
				@matchEntryArray << matchEntry
			else
				matchEntry = MatchEntryData.new
				@matchEntryArray << matchEntry
			end	
			index+=1
		end
	end

	def update
		action = params[:commit]		
		
		if action == 'Cancel'
			redirect_to controller: 'match_weeks' and return
		else		
			match_week = MatchWeek.find_by(id: params[:id])
			matches = Match.where(match_week_id: params[:id]).order(id: :asc)
			match_week.update(week: params["week"])
			match_week.update(year: params["year"])
			matchNum = 0
			while matchNum < 16 do
				team1Selected = params["match#{matchNum}_team1"]
				team2Selected = params["match#{matchNum}_team2"]
				homeTeam = params["match#{matchNum}_hometeam"]
				spread = params["match#{matchNum}_spread"]
				favoredTeam = params["match#{matchNum}_favoredteam"]
				date = params["match#{matchNum}_date"]
				time = params["match#{matchNum}_time"]
				if matches[matchNum].present?
					if team1Selected == 'Arizona Cardinals' && team2Selected == 'Arizona Cardinals' &&
						homeTeam.blank? && spread.blank? && favoredTeam.blank? && 
						date.blank? && time.blank?
						matches[matchNum].destroy
					else
						matches[matchNum].update(week: params["week"])
						matches[matchNum].update(team1: team1Selected)
						matches[matchNum].update(team2: team2Selected)
						matches[matchNum].update(home_team: homeTeam)
						matches[matchNum].update(spread: spread)
						matches[matchNum].update(favored_team: favoredTeam)
						matches[matchNum].update(date: date)
						matches[matchNum].update(time: time)
					end
				else
					if team1Selected.present? && team2Selected.present? &&
						homeTeam.present? && spread.present? && favoredTeam.present? && 
						date.present? && time.present?
			
						match_week.matches.create(year: params["year"], week: params["week"], match_num: matchNum, team1: team1Selected, team2: team2Selected, 
													home_team: homeTeam, spread: spread, favored_team: favoredTeam, date: date, time: time)
					end
		
				end	
				matchNum+=1
			end
			redirect_to controller: 'match_weeks'
		end
	end

	def destroy
		@match_week=MatchWeek.find(params[:id])
		@match_week.destroy

		redirect_to controller: 'match_weeks'
	end

	def to_xml
		require 'builder'
		require 'nokogiri'
		match_week = MatchWeek.find(params[:match_week_id])
		matches = Match.where(match_week_id: params[:match_week_id]).order(id: :asc)
		matchNum = 0
		_,weekNum = match_week.week.split("Week") 
		builder = Nokogiri::XML::Builder.new do |xml|
    			xml.week do |week|
    				xml.number weekNum
    				while matchNum < match_week.matches.count do
    					team1Selected = matches[matchNum].team1
			  			team2Selected = matches[matchNum].team2
			  			homeTeam = matches[matchNum].home_team
		  				spread = matches[matchNum].spread
		  				favoredTeam = matches[matchNum].favored_team
		  				date = matches[matchNum].date
		  				time = matches[matchNum].time
	   					xml.match do |xml|
	    					xml.team1 team1Selected
	    					xml.team2 team2Selected
	    					xml.home homeTeam
	    					xml.spread spread
	    					xml.favored favoredTeam
	    					xml.date date
	    					xml.time time
	    				end
	    				matchNum+=1
  	 				end	
   				end
  			end
		  	File.open("public/#{match_week.week.downcase}.xml", "w+") do |f|
   				f.write(builder.to_xml)
		 	end
		send_file(
  				  "#{Rails.root}/public/#{match_week.week.downcase}.xml",
    				filename: "#{match_week.week.downcase}.xml",
    			type: "application/xml"
  				)
	end

	def to_html
		require 'builder'
		require 'nokogiri'
		match_week = MatchWeek.find(params[:match_week_id])
		matches = Match.where(match_week_id: params[:match_week_id]).order(id: :asc)
		weekSelected = match_week.week
		matchNum = 0
		builder = Nokogiri::HTML::Builder.new do |doc|
		  doc.html {
		    doc.body{
		    	doc.span{
		    		doc.b{
		    			doc.text weekSelected.upcase
		    		} 

		    	}
		     doc.br
		     doc.br
		     doc.table(:cellspacing => "0", :border => "0"){
		      	doc.tr{
		      		doc.th(:style => "border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000", 
		      			:width =>"127") {
		      			doc.text "Date & Time"
		      		}
		      		doc.th(:style => "border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000", 
		      			:width =>"180") {
		      			doc.text "Favorite"
		      		}
		      		doc.th(:style => "border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000", 
		      			:width => "85"){ 
		      			doc.text "Spread"
		      		}
		      		doc.th(:style => "border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000", 
		      			:width => "180"){ 
		      			doc.text "Underdog"
		      		}
		      	}
		      	while matchNum < match_week.matches.count do
   					team1Selected = matches[matchNum].team1
					team2Selected = matches[matchNum].team2
					homeTeam = matches[matchNum].home_team
		  			spread = matches[matchNum].spread
		  			favoredTeam = matches[matchNum].favored_team
		  			date = matches[matchNum].date
		  			time = matches[matchNum].time
		 			underdogTeam = ""
		 			if team1Selected.include? favoredTeam
		 				if team1Selected.include? homeTeam
		 					favoredTeam = "At " + team1Selected
		 				else
		 					underdogTeam = "At "	
		 					favoredTeam = team1Selected								
		 				end
		 				underdogTeam = underdogTeam + team2Selected
		 			else
		 				if team2Selected.include? homeTeam
		 					favoredTeam = "At " + team2Selected
		 				else
		 					underdogTeam = "At "
		 					favoredTeam = team2Selected								
		 				end
		 				underdogTeam = underdogTeam + team1Selected
		 			end
	 				doc.tr(:align => "center"){
		 					doc.td(:style => "border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000"){
		 						doc.text date + " " + time
		 					}
		 					doc.td(:style => "border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000"){
		 						doc.text favoredTeam
		 					}
		 					doc.td(:style => "border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000"){
		 						doc.text spread
		 					}
		 					doc.td(:style => "border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000"){
		 						doc.text underdogTeam
		 					}
	 				}		 				
		 			matchNum+=1
		 		end
		 	  }
		   }
	     }
		end
		File.open("public/#{weekSelected}.html", "w+") do |f|
   			f.write(builder.to_html)
		end
		
		send_file(
  				  "#{Rails.root}/public/#{weekSelected}.html",
    				filename: "#{weekSelected}.html",
    			type: "application/html"
  				)

	end
end

class MatchEntryData
	include ActiveModel::Conversion
  	extend  ActiveModel::Naming
  	attr_reader :team1, :team2, :hometeam, :favoredteam, :spread, :date, :time
  	attr_writer :team1, :team2, :hometeam, :favoredteam, :spread, :date, :time
  	
	def persisted?
    	false
  	end

  	def initialize(team1=nil, team2=nil, hometeam=nil, favoredteam=nil, spread=nil, date=nil, time=nil)
  		@team1= team1
  		@team2=team2
  		@hometeam=hometeam
  		@favoredteam=favoredteam
  		@spread=spread
  		@date=date
  		@time=time
  	end
 end
