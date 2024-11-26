class CreateTopics < ActiveRecord::Migration[7.1]
  def change
    create_table :topics do |t|
      t.integer :course_id
      t.string :title

      t.timestamps
    end
  end
end
