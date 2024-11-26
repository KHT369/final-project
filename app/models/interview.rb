# == Schema Information
#
# Table name: interviews
#
#  id             :bigint           not null, primary key
#  company        :string
#  division       :string
#  interview_type :string
#  term_offered   :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Interview < ApplicationRecord
  has_many  :enrollments, class_name: "Enrollment", foreign_key: "interview_id", dependent: :destroy
  has_many  :questions, class_name: "Question", foreign_key: "interview_id", dependent: :destroy
  has_many :users, through: :enrollments, source: :user
end
