class AddDescriptionToInterviews < ActiveRecord::Migration[7.1]
  def change
    add_column :interviews, :description, :string
  end
end
