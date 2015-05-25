# == Schema Information
#
# Table name: exercise_workouts
#
#  id          :integer          not null, primary key
#  exercise_id :integer          not null
#  workout_id  :integer          not null
#  position    :integer          not null
#  points      :float            default(1.0)
#  created_at  :datetime
#  updated_at  :datetime
#


# =============================================================================
# Represents a many-to-many relationship between exercises and workouts,
# indicating which exercises are included in a given workout, and in
# what order.  The order is determined by "position", which starts at 1.
#
class ExerciseWorkout < ActiveRecord::Base

  #~ Relationships ............................................................

  belongs_to :exercise, inverse_of: :exercise_workouts
  belongs_to :workout, inverse_of: :exercise_workouts
  acts_as_list scope: :workout


  #~ Validation ...............................................................

  validates :exercise, presence: true
  validates :workout, presence: true

  # Note: position should not be validated, since it is auto-updated in
  # a hook after validation.


  #~ Class methods ............................................................

  # -------------------------------------------------------------
  #return the points for an exercise belonging to a particular workout
  def self.findExercisePoints(ex, wktid)
    return ExerciseWorkout.find_by(exercise: ex, workout_id: wktid).points
  end
end
