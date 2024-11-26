class InterviewsController < ApplicationController
  def index
    matching_interviews = Interview.all

    @list_of_interviews = matching_interviews.order({ :created_at => :desc })

    render({ :template => "interviews/index" })
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

    if the_interview.valid?
      the_interview.save
      redirect_to("/interviews", { :notice => "Interview created successfully." })
    else
      redirect_to("/interviews", { :alert => the_interview.errors.full_messages.to_sentence })
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
