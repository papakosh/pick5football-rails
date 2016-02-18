class CreatePicks < ActiveRecord::Migration
  def change
    create_table :picks do |t|
      t.text :teams
      t.boolean :submitted
      t.references :user, index: true
      t.references :matchweek, index: true

      t.timestamps
    end
  end
end
