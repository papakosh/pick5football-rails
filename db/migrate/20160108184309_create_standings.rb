class CreateStandings < ActiveRecord::Migration[4.2]
  def change
    create_table :standings do |t|
      t.integer :wins
      t.string :year
      t.references :match_week, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
