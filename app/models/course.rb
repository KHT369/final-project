class Course < ApplicationRecord
  has_many  :enrollments, class_name: "Enrollment", foreign_key: "course_id", dependent: :destroy
  has_many  :topics, class_name: "Topic", foreign_key: "course_id", dependent: :destroy
  has_many :users, through: :enrollments, source: :user
end
