class CreateMatchWeeks < ActiveRecord::Migration
  def change
    create_table :match_weeks do |t|
      t.string :year
      t.integer :week

      t.timestamps
    end
  end
end
