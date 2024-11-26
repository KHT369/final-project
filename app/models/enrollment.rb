# == Schema Information
#
# Table name: enrollments
#
#  id           :bigint           not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  course_id    :integer
#  interview_id :integer
#  user_id      :integer
#
class Enrollment < ApplicationRecord
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
  belongs_to :course, required: true, class_name: "Course", foreign_key: "course_id"
  belongs_to :interview, required: true, class_name: "Interview", foreign_key: "interview_id"
end
