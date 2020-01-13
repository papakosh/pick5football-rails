class FixColumnNamePicks < ActiveRecord::Migration[4.2]
  def change
  	rename_column :picks, :matchweek_id, :match_week_id
  end
end
