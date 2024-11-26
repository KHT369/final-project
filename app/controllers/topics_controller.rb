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
      redirect_to("/topics", { :notice => "Topic created successfully." })
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
