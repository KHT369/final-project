class Topic < ApplicationRecord
  belongs_to :course, required: true, class_name: "Course", foreign_key: "course_id"
  has_many  :questions, class_name: "Question", foreign_key: "topic_id", dependent: :destroy
end
