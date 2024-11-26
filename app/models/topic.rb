# == Schema Information
#
# Table name: topics
#
#  id         :bigint           not null, primary key
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :integer
#
class Topic < ApplicationRecord
  belongs_to :course, required: true, class_name: "Course", foreign_key: "course_id"
  has_many  :questions, class_name: "Question", foreign_key: "topic_id", dependent: :destroy
end
