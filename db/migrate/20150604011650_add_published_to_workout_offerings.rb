class AddPublishedToWorkoutOfferings < ActiveRecord::Migration
  def change
    add_column :workout_offerings, :published, :boolean,
      null: false, default: false
  end
end
