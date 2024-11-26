class CreateInterviews < ActiveRecord::Migration[7.1]
  def change
    create_table :interviews do |t|
      t.string :company
      t.string :interview_type
      t.string :term_offered
      t.string :division

      t.timestamps
    end
  end
end
