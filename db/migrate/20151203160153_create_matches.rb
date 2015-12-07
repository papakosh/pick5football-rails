class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.string :year
      t.integer :week
      t.integer :match_num
      t.string :team1
      t.string :team2
      t.string :home_team
      t.decimal :spread
      t.string :favored_team
      t.string :date
      t.string :time
      t.references :MatchWeek, index: true

      t.timestamps
    end
  end
end
