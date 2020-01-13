class FixColumnName < ActiveRecord::Migration[4.2]
  def change
  	rename_column :matches, :MatchWeek_id, :match_week_id
  end
end
