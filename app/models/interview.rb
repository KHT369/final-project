class Interview < ApplicationRecord
  has_many  :enrollments, class_name: "Enrollment", foreign_key: "interview_id", dependent: :destroy
  has_many  :questions, class_name: "Question", foreign_key: "interview_id", dependent: :destroy
  has_many :users, through: :enrollments, source: :user
end
