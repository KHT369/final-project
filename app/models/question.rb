# == Schema Information
#
# Table name: questions
#
#  id           :bigint           not null, primary key
#  answer       :string
#  authenticity :string
#  body         :string
#  role         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  interview_id :integer
#  topic_id     :integer
#  user_id      :integer
#
class Question < ApplicationRecord
  belongs_to :user, required: false, class_name: "User", foreign_key: "user_id"
  belongs_to :topic, required: false, class_name: "Topic", foreign_key: "topic_id"
  belongs_to :interview, required: false, class_name: "Interview", foreign_key: "interview_id"
end
