class MatchWeeksController < ApplicationController
	def index
		#@matches = Match.all
		@match_weeks = MatchWeek.all
	end

	def show
		#@matches = Match.where(year: "2015", week: "2")
	end

	def new
		@match_week = MatchWeek.new
		@match = Match.new
	end

	def edit
		@match_week = MatchWeek.find(params[:id])
		@match = Match.where(match_week_id: params[:id])
	end


	def create
		week_selected = params["week"]
		year_selected = params["year"]
		match_num = 1
		#_,week_num = week_selected.split("week")
		@match_week = MatchWeek.create(year: year_selected, week: week_selected)

		while match_num < 17 do
			team1_selected = params["match#{match_num}_team1"]
			team2_selected = params["match#{match_num}_team2"]
			home_team = params["match#{match_num}_hometeam"]
			spread = params["match#{match_num}_spread"]
			favored = params["match#{match_num}_favored"]
			date = params["match#{match_num}_date"]
			time = params["match#{match_num}_time"]
		
			if team1_selected.present? && team2_selected.present? &&
				home_team.present? && spread.present? && favored.present? && 
				date.present? && time.present?
		
				@match_week.matches.create(year: year_selected, week: week_selected, match_num: match_num, team1: team1_selected, team2: team2_selected, 
											home_team: home_team, spread: spread, favored_team: favored, date: date, time: time)
		
			end
			match_num=match_num + 1

		end

		redirect_to '/match_weeks'
	end

	def update
		@match_week = MatchWeek.find(params[:id])
		@match = Match.where(match_week_id: params[:id])
		week_selected = params["week"]
		year_selected = params["year"]
		@match_week.update(week: week_selected)
		@match_week.update(year: year_selected)
		match_num = 1
		while match_num < @match_week.matches.count+1 do
			team1_selected = params["match#{match_num}_team1"]
			team2_selected = params["match#{match_num}_team2"]
			home_team = params["match#{match_num}_hometeam"]
			spread = params["match#{match_num}_spread"]
			favored = params["match#{match_num}_favored"]
			date = params["match#{match_num}_date"]
			time = params["match#{match_num}_time"]
		
			@match[match_num-1].update(week: week_selected)
			@match[match_num-1].update(team1: team1_selected)
			@match[match_num-1].update(team2: team2_selected)
			@match[match_num-1].update(home_team: home_team)
			@match[match_num-1].update(spread: spread)
			@match[match_num-1].update(favored_team: favored)
			@match[match_num-1].update(date: date)
			@match[match_num-1].update(time: time)
			
			match_num = match_num + 1
		end
		redirect_to '/match_weeks'
	end

	def to_xml
		require 'builder'
		require 'nokogiri'
		#puts "MATCH DATA MAGICALLY TO XML"
		@match_week = MatchWeek.find(params[:match_week_id])
		#puts "WEEK = #{@match_week.week}"
		@matches = Match.where(match_week_id: params[:match_week_id])
		match_num = 1
		_,week_num = @match_week.week.split("Week") 
		builder = Nokogiri::XML::Builder.new do |xml|
    			xml.week do |week|
    				xml.number week_num
    				while match_num < @match_week.matches.count+1 do
    					team1_selected = @matches[match_num-1].team1
			  			team2_selected = @matches[match_num-1].team2
			  			home_team = @matches[match_num-1].home_team
		  				spread = @matches[match_num-1].spread
		  				favored = @matches[match_num-1].favored_team
		  				date = @matches[match_num-1].date
		  				time = @matches[match_num-1].time
	   					xml.match do |xml|
	    					xml.team1 team1_selected
	    					xml.team2 team2_selected
	    					xml.home home_team
	    					xml.spread spread
	    					xml.favored favored
	    					xml.date date
	    					xml.time time
	    				end
	    				match_num=match_num+1
  	 				end	
   				end
  			end
		  	File.open("#{@match_week.week.downcase}.xml", "a+") do |f|
   				f.write(builder.to_xml)
		 	end
		redirect_to '/match_weeks'
	end

	def to_html
		require 'builder'
		require 'nokogiri'
		#  	builder = Nokogiri::HTML::Builder.new do |doc|
		#  	  doc.html {
		#  	    doc.body{
		#  	    	doc.span{
		#  	    		doc.b{
		#  	    			doc.text week_selected.upcase
		#  	    		} 

		#  	    	}
		#  	      doc.br
		#  	      doc.br
		#  	      doc.table(:cellspacing => "0", :border => "0"){
		#  	      	doc.tr{
		#  	      		doc.th(:style => "border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000", 
		#  	      			:width =>"127") {
		#  	      			doc.text "Date & Time"
		#  	      		}
		#  	      		doc.th(:style => "border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000", 
		#  	      			:width =>"160") {
		#  	      			doc.text "Favorite"
		#  	      		}
		#  	      		doc.th(:style => "border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000", 
		#  	      			:width => "85"){ 
		#  	      			doc.text "Spread"
		#  	      		}
		#  	      		doc.th(:style => "border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000", 
		#  	      			:width => "160"){ 
		#  	      			doc.text "Underdog"
		#  	      		}
		#  	      	}
		#  	      	while match_num < 17 do
  #  						team1_selected = params["match#{match_num}_team1"]
		#  				team2_selected = params["match#{match_num}_team2"]
		#  				home_team = params["match#{match_num}_hometeam"]
		#  				spread = params["match#{match_num}_spread"]
		#  				favored = params["match#{match_num}_favored"]
		#  				date = params["match#{match_num}_date"]
		#  				time = params["match#{match_num}_time"]
		#  				underdog = ""
		#  				if team1_selected.include? favored
		#  					if team1_selected.include? home_team
		#  						favored = "At " + team1_selected
		#  					else
		#  						underdog = "At "									
		#  					end
		#  					underdog = underdog + team2_selected
		#  				else
		#  					if team2_selected.include? home_team
		#  						favored = "At " + team2_selected
		#  					else
		#  						underdog = "At "									
		#  					end
		#  					underdog = underdog + team1_selected
		#  				end

		#  				if team1_selected.present? && team2_selected.present? &&
		#  					home_team.present? && spread.present? && favored.present? && 
		#  					date.present? && time.present?
		#  					@match = Match.create(year: year_selected, week: week_num, match_num: match_num, team1: team1_selected, team2: team2_selected, 
		#  										home_team: home_team, spread: spread, favored_team: favored, date: date, time: time)

		#  					doc.tr(:align => "center"){
		#  						doc.td(:style => "border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000"){
		#  							doc.text date + " " + time
		#  						}
		#  						doc.td(:style => "border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000"){
		#  							doc.text favored
		#  						}
		#  						doc.td(:style => "border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000"){
		#  							doc.text spread
		#  						}
		#  						doc.td(:style => "border-top:1px solid #000000;border-bottom:1px solid #000000;border-left:1px solid #000000;border-right:1px solid #000000"){
		#  							doc.text underdog
		#  						}
		#  					}
		#  				end
		#  				match_num = match_num + 1
		#  			end
		#  	      }
		#  	    }
		#  	  }
		#  	end
		#  	File.open("#{week_selected}.html", "a+") do |f|
  #  				f.write(builder.to_html)
		#  	end
	
	end
end
