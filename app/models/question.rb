class Question < ApplicationRecord
  belongs_to :user, required: true, class_name: "User", foreign_key: "user_id"
  belongs_to :topic, required: true, class_name: "Topic", foreign_key: "topic_id"
  belongs_to :interview, required: true, class_name: "Interview", foreign_key: "interview_id"
end
