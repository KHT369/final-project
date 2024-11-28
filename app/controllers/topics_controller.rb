class TopicsController < ApplicationController
  def index
    matching_topics = Topic.all

    @list_of_topics = matching_topics.order({ :created_at => :desc })

    render({ :template => "topics/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_topics = Topic.where({ :id => the_id })

    @the_topic = matching_topics.at(0)

    render({ :template => "topics/show" })
  end

  def create
    the_topic = Topic.new
    the_topic.course_id = params.fetch("query_course_id")
    the_topic.title = params.fetch("query_title")

    if the_topic.valid?
      the_topic.save

      # Create system message

      system_question = Question.new
      system_question.topic_id = the_topic.id
      system_question.role = "system"
      system_question.user_id = current_user.id
      system_question.body = "You are a #{the_topic.course.course_name} Professor. Create a practice exam on #{the_topic.title} to help the user prepare for a final exam. Ask whether the user wants you to automatically generate questions on #{the_topic.title} or if they would like to submit questions for you to base the practice exam on. If the user responds with a list of questions, generate questions based on the submitted list. If the user does not submit a list of questions, proceed to generate your own. Ask the questions one at a time. Do not give the answers until the very end and don't ask a question when you give the answers. After the user has answered all the questions give them a score out of 100 and walk them through each question one step at a time and correct their mistakes."
      
      system_question.authenticity = "generated"
      system_question.save

      # Create first user message

      user_question = Question.new
      user_question.role = "user"
      user_question.topic_id = the_topic.id
      user_question.user_id = current_user.id
      user_question.body = "Can you ask me if I want to submit my own questions for you to base the #{the_topic.title} exam off of or generate an exam without submitting a question list?"
      user_question.authenticity = "generated"
      # user_question.answer = "user" Need to use an if then statement here
      if user_question.body.include?("?")
        user_question.answer = "no"
      else
        user_question.answer = "yes" # Or any other default value you prefer
      end
      user_question.save

      # Call API to get first assistant message

      client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

      question_list = [
        {
          "role" => "system",
          "content" => "You are a #{the_topic.course.course_name} Professor. Create a practice exam on #{the_topic.title} to help the user prepare for a final exam. Ask whether the user wants you to automatically generate questions on #{the_topic.title} or if they would like to submit questions for you to base the practice exam on. If the user responds with a list of questions, generate questions based on the submitted list. If the user does not submit a list of questions, proceed to generate your own. Ask the questions one at a time. Do not give the answers until the very end and don't ask a question when you give the answers. After the user has answered all the questions give them a score out of 100 and walk them through each question one step at a time and correct their mistakes."
      
        },
        {
          "role" => "user",
          "content" => "Can you ask me if I want to submit my own questions for you to base the #{the_topic.title} exam off of or generate an exam without submitting a question list?"
        }
      ]

      api_response = client.chat(
        parameters: {
          model: ENV.fetch("OPENAI_MODEL"),
          messages: question_list
        }
      )

      assistant_content = api_response.fetch("choices").at(0).fetch("message").fetch("content")

      assistant_question = Question.new
      assistant_question.role = "assistant"
      assistant_question.topic_id = the_topic.id
      assistant_question.body = assistant_content
      assistant_question.authenticity = "generated"
      assistant_question.user_id = current_user.id
      # assistant_question.answer = "system" Need to use if then statement
      if assistant_question.body.include?("?")
        assistant_question.answer = "no"
      else
        assistant_question.answer = "yes" # Or any other default value you prefer
      end
      assistant_question.save


      redirect_to("/topics/#{the_topic.id}", { :notice => "Topic created successfully." })
    else
      redirect_to("/topics", { :alert => the_topic.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_topic = Topic.where({ :id => the_id }).at(0)

    the_topic.course_id = params.fetch("query_course_id")
    the_topic.title = params.fetch("query_title")

    if the_topic.valid?
      the_topic.save
      redirect_to("/topics/#{the_topic.id}", { :notice => "Topic updated successfully."} )
    else
      redirect_to("/topics/#{the_topic.id}", { :alert => the_topic.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_topic = Topic.where({ :id => the_id }).at(0)

    the_topic.destroy

    redirect_to("/courses/#{the_topic.course_id}", { :notice => "Topic deleted successfully."} )
  end
end
