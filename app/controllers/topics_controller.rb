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
      system_question.body = "You are a #{the_topic.title} mock interviewer. Generate an interview on #{the_topic.title} to simulate a real interview. Start by asking the user to tell you about themselves. Follow up after the user replies with behavioral questions. Ask 5 to 10 behavioral questions one at a time to the user. Then move on to a case question on #{the_topic.title}. For the case, make the structure similar to a consulting or technology interview case. During the case, remember to give them information if they ask any clarifying questions. After both the behavioral portion and the casing portion of the interview is over, please assess the user's answers and give them feedback on where they could improve."
      system_question.authenticity = "generated"
      system_question.save

      # Create first user message

      user_question = Question.new
      user_question.role = "user"
      user_question.topic_id = the_topic.id
      user_question.body = "Can you mock interview me about #{the_topic.title} and then provide feedback after?"
      user_question.authenticity = "generated"
      # user_question.answer = "user" Need to use an if then statement here
      if user_question.body.include?("?")
        user_question.answer = "yes"
      else
        user_question.answer = "no" # Or any other default value you prefer
      end
      user_question.save

      # Call API to get first assistant message

      client = OpenAI::Client.new(access_token: ENV.fetch("OPENAI_API_KEY"))

      question_list = [
        {
          "role" => "system",
          "content" => "You are a #{the_topic.title} mock interviewer. Generate an interview on #{the_topic.title} to simulate a real interview. Start by asking the user to tell you about themselves. Follow up after the user replies with behavioral questions. Ask 5 to 10 behavioral questions one at a time to the user. Then move on to a case question on #{the_topic.title}. For the case, make the structure similar to a consulting or technology interview case. During the case, remember to give them information if they ask any clarifying questions. After both the behavioral portion and the casing portion of the interview is over, please assess the user's answers and give them feedback on where they could improve."
      
        },
        {
          "role" => "user",
          "content" => "Can you mock interview me about #{the_topic.title} and then provide feedback after?"
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
      # assistant_question.answer = "system" Need to use if then statement
      if assistant_question.body.include?("?")
        assistant_question.answer = "yes"
      else
        assistant_question.answer = "no" # Or any other default value you prefer
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

    redirect_to("/topics", { :notice => "Topic deleted successfully."} )
  end
end
