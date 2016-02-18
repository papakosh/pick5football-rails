class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :user_id
      t.string :name
      t.string :user_type

      t.timestamps
    end
  end
end
