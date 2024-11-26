class EnrollmentsController < ApplicationController
  def index
    matching_enrollments = Enrollment.all

    @list_of_enrollments = matching_enrollments.order({ :created_at => :desc })

    render({ :template => "enrollments/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_enrollments = Enrollment.where({ :id => the_id })

    @the_enrollment = matching_enrollments.at(0)

    render({ :template => "enrollments/show" })
  end

  def create
    the_enrollment = Enrollment.new
    the_enrollment.user_id = params.fetch("query_user_id")
    the_enrollment.course_id = params.fetch("query_course_id")
    the_enrollment.interview_id = params.fetch("query_interview_id")

    if the_enrollment.valid?
      the_enrollment.save
      redirect_to("/enrollments", { :notice => "Enrollment created successfully." })
    else
      redirect_to("/enrollments", { :alert => the_enrollment.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_enrollment = Enrollment.where({ :id => the_id }).at(0)

    the_enrollment.user_id = params.fetch("query_user_id")
    the_enrollment.course_id = params.fetch("query_course_id")
    the_enrollment.interview_id = params.fetch("query_interview_id")

    if the_enrollment.valid?
      the_enrollment.save
      redirect_to("/enrollments/#{the_enrollment.id}", { :notice => "Enrollment updated successfully."} )
    else
      redirect_to("/enrollments/#{the_enrollment.id}", { :alert => the_enrollment.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_enrollment = Enrollment.where({ :id => the_id }).at(0)

    the_enrollment.destroy

    redirect_to("/enrollments", { :notice => "Enrollment deleted successfully."} )
  end
end
