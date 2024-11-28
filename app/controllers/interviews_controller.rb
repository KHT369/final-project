class InterviewsController < ApplicationController
  def index
    # Start with all interviews
    matching_interviews = Interview.all
  
    # Apply filters
    if params[:filter_company].present?
      matching_interviews = matching_interviews.where(company: params[:filter_company])
    end
  
    if params[:filter_type].present?
      matching_interviews = matching_interviews.where(interview_type: params[:filter_type])
    end
  
    if params[:filter_division].present?
      matching_interviews = matching_interviews.where(division: params[:filter_division])
    end
  
    # Order the filtered interviews
    @list_of_interviews = matching_interviews.order(created_at: :desc)
  
    # Fetch distinct values for dropdowns
    @companies = Interview.distinct.pluck(:company).compact
    @types = Interview.distinct.pluck(:interview_type).compact
    @divisions = Interview.distinct.pluck(:division).compact
  
    render(template: "interviews/index")
  end

  def show
    the_id = params.fetch("path_id")

    matching_interviews = Interview.where({ :id => the_id })

    @the_interview = matching_interviews.at(0)

    render({ :template => "interviews/show" })
  end

  def create
    the_interview = Interview.new
    the_interview.company = params.fetch("query_company")
    the_interview.interview_type = params.fetch("query_interview_type")
    the_interview.term_offered = params.fetch("query_term_offered")
    the_interview.division = params.fetch("query_division")
    the_interview.description = params.fetch("query_description")
    

    if the_interview.valid?
      the_interview.save

    # Create system message

    system_question = Question.new
    system_question.interview_id = the_interview.id
    system_question.role = "system"
    system_question.body = "You are a #{the_interview.division} #{the_interview.description} mock interviewer from #{the_interview.company}. Generate a #{the_interview.interview_type} interview on #{the_interview.division} #{the_interview.description} to simulate a real interview. Start by asking the user to tell you about themselves. Follow up after the user replies with behavioral questions. Ask 5 to 10 behavioral questions one at a time to the user. Then move on to a case question for #{the_interview.division} #{the_interview.description}. For the case, make the structure similar to a consulting or technology interview case. During the case, remember to give them information if they ask any clarifying questions. After both the behavioral portion and the casing portion of the interview is over, please assess the user's answers and give them feedback on where they could improve."
    system_question.authenticity = "generated"
    system_question.save

    # Create first user message

    user_question = Question.new
    user_question.role = "user"
    user_question.interview_id = the_interview.id
    user_question.body = "Can you mock interview me about #{the_interview.division} #{the_interview.description} and then provide feedback after?"
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
        "content" => "You are a #{the_interview.division} #{the_interview.description} mock interviewer from #{the_interview.company}. Generate a #{the_interview.interview_type} interview on #{the_interview.division} #{the_interview.description} to simulate a real interview. Start by asking the user to tell you about themselves. Follow up after the user replies with behavioral questions. Ask 5 to 10 behavioral questions one at a time to the user. Then move on to a case question for #{the_interview.division} #{the_interview.description}. For the case, make the structure similar to a consulting or technology interview case. During the case, remember to give them information if they ask any clarifying questions. After both the behavioral portion and the casing portion of the interview is over, please assess the user's answers and give them feedback on where they could improve."
    
      },
      {
        "role" => "user",
        "content" => "Can you mock interview me about #{the_interview.division} #{the_interview.description} and then provide feedback after?"
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
    assistant_question.interview_id = the_interview.id
    assistant_question.body = assistant_content
    assistant_question.authenticity = "generated"
    # assistant_question.answer = "system" Need to use if then statement
    if assistant_question.body.include?("?")
      assistant_question.answer = "no"
    else
      assistant_question.answer = "yes" # Or any other default value you prefer
    end
    assistant_question.save

      redirect_to("/interviews/#{the_interview.id}", { :notice => "Interview created successfully." })
    else
      redirect_to("/interviews/#{the_interview.id}", { :alert => the_interview.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_interview = Interview.where({ :id => the_id }).at(0)

    the_interview.company = params.fetch("query_company")
    the_interview.interview_type = params.fetch("query_interview_type")
    the_interview.term_offered = params.fetch("query_term_offered")
    the_interview.division = params.fetch("query_division")

    if the_interview.valid?
      the_interview.save
      redirect_to("/interviews/#{the_interview.id}", { :notice => "Interview updated successfully."} )
    else
      redirect_to("/interviews/#{the_interview.id}", { :alert => the_interview.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_interview = Interview.where({ :id => the_id }).at(0)

    the_interview.destroy

    redirect_to("/interviews", { :notice => "Interview deleted successfully."} )
  end
end
