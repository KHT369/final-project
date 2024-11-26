# == Schema Information
#
# Table name: courses
#
#  id           :bigint           not null, primary key
#  course_name  :string
#  description  :string
#  term_offered :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class Course < ApplicationRecord
  has_many  :enrollments, class_name: "Enrollment", foreign_key: "course_id", dependent: :destroy
  has_many  :topics, class_name: "Topic", foreign_key: "course_id", dependent: :destroy
  has_many :users, through: :enrollments, source: :user
end
