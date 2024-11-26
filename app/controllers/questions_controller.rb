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
    the_question.role = params.fetch("query_role")
    the_question.authenticity = params.fetch("query_authenticity")
    the_question.answer = params.fetch("query_answer")
    the_question.user_id = params.fetch("query_user_id")
    the_question.interview_id = params.fetch("query_interview_id")

    if the_question.valid?
      the_question.save
      redirect_to("/questions", { :notice => "Question created successfully." })
    else
      redirect_to("/questions", { :alert => the_question.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_question = Question.where({ :id => the_id }).at(0)

    the_question.topic_id = params.fetch("query_topic_id")
    the_question.body = params.fetch("query_body")
    the_question.role = params.fetch("query_role")
    the_question.authenticity = params.fetch("query_authenticity")
    the_question.answer = params.fetch("query_answer")
    the_question.user_id = params.fetch("query_user_id")
    the_question.interview_id = params.fetch("query_interview_id")

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
