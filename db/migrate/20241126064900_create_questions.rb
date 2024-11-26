class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.integer :topic_id
      t.string :body
      t.string :role
      t.string :authenticity
      t.string :answer
      t.integer :user_id
      t.integer :interview_id

      t.timestamps
    end
  end
end
