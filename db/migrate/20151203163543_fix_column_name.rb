class FixColumnName < ActiveRecord::Migration
  def change
  	rename_column :matches, :MatchWeek_id, :match_week_id
  end
end
