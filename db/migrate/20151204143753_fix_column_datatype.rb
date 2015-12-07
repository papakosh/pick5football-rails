class FixColumnDatatype < ActiveRecord::Migration
  def change
  	change_column :match_weeks, :week, :string
  	change_column :matches, :week, :string
  end
end
