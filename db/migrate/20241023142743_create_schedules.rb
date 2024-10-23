class CreateSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :schedules do |t|
      t.integer :week_day
      t.string :close_time
      t.string :open_time
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
