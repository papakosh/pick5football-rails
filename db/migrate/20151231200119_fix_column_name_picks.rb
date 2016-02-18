class FixColumnNamePicks < ActiveRecord::Migration
  def change
  	rename_column :picks, :matchweek_id, :match_week_id
  end
end
