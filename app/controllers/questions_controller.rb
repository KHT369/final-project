class QuestionsController < ApplicationController
  def index
    matching_questions = Question.all

    @list_of_questions = matching_questions.order({ :created_at => :desc })

    render({ :template => "questions/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_questions = Question.where({ :id => the_id })

    @the_question = matching_questions.at(0)

    render({ :template => "questions/show" })
  end

  def create
    the_question = Question.new
    the_question.topic_id = params.fetch("query_topic_id")
    the_question.body = params.fetch("query_body")
    the_question.role = "user"
    the_question.authenticity = "generated"
    the_question.user_id = params.fetch("query_user_id")
    if the_question.body.include?("?")
      the_question.answer = "no"
    else
      the_question.answer = "yes" # Or any other default value you prefer
    end

    if the_question.valid?
      the_question.save

      question_list = []

      the_question.topic.questions.order(:created_at).each do |the_question|
        message_hash = {
          "role" => the_question.role,
          "content" => the_question.body,
          "authenticity" => the_question.authenticity,
        }

        question_list.push(message_hash)
      end

      client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

      api_response = client.chat(
        parameters: {
          model: ENV.fetch("OPENAI_MODEL"),
          messages: question_list
        }
      )

      new_assistant_question = Question.new
      new_assistant_question.role = "assistant"
      new_assistant_question.topic_id = the_question.topic_id
      new_assistant_question.body = api_response.fetch("choices").at(0).fetch("message").fetch("content")
      new_assistant_question.save

      redirect_to("/topics/#{the_question.topic_id}", { :notice => "Question created successfully." })
    else
      redirect_to("/topics/#{the_question.topic_id}", { :alert => the_question.errors.full_messages.to_sentence })
    end
  end

  def create_interview
    the_question = Question.new
    the_question.interview_id = params.fetch("query_interview_id")
    the_question.body = params.fetch("query_body")
    the_question.role = "user"
    the_question.authenticity = "generated"
    the_question.user_id = params.fetch("query_user_id")
    if the_question.body.include?("?")
      the_question.answer = "no"
    else
      the_question.answer = "yes" # Or any other default value you prefer
    end

    if the_question.valid?
      the_question.save

      question_list = []

      the_question.interview.questions.order(:created_at).each do |the_question|
        message_hash = {
          "role" => the_question.role,
          "content" => the_question.body,
          "authenticity" => the_question.authenticity,
        }

        question_list.push(message_hash)
      end

      client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

      api_response = client.chat(
        parameters: {
          model: ENV.fetch("OPENAI_MODEL"),
          messages: question_list
        }
      )

      new_assistant_question = Question.new
      new_assistant_question.role = "assistant"
      new_assistant_question.interview_id = the_question.interview_id
      new_assistant_question.body = api_response.fetch("choices").at(0).fetch("message").fetch("content")
      new_assistant_question.save

      redirect_to("/interviews/#{the_question.interview_id}", { :notice => "Question created successfully." })
    else
      redirect_to("/interviews/#{the_question.interview_id}", { :alert => the_question.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_question = Question.where({ :id => the_id }).at(0)

    the_question.topic_id = params.fetch("query_topic_id")
    the_question.body = params.fetch("query_body")
    the_question.role = params.fetch("query_role")
    the_question.authenticity = params.fetch("query_authenticity")

    if the_question.valid?
      the_question.save
      redirect_to("/questions/#{the_question.id}", { :notice => "Question updated successfully."} )
    else
      redirect_to("/questions/#{the_question.id}", { :alert => the_question.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_question = Question.where({ :id => the_id }).at(0)

    the_question.destroy

    redirect_to("/questions", { :notice => "Question deleted successfully."} )
  end
end
