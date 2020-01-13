class CreateMatchWeeks < ActiveRecord::Migration[4.2]
  def change
    create_table :match_weeks do |t|
      t.string :year
      t.integer :week

      t.timestamps
    end
  end
end
