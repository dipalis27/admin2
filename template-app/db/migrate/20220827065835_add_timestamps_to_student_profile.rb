class AddTimestampsToStudentProfile < ActiveRecord::Migration[6.0]
  def change
    add_timestamps :student_profiles, null: false, default: -> { 'NOW()' }
  end
end
