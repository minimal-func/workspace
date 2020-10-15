module Wiki
  class TopicsController < ApplicationController

    def new
      @topic = Wiki::Topic.new
    end

    def create
      @topic = Wiki::Topic.new(topic_params)
      @topic.created_by = current_user.id
      @topic.save
      redirect_to wiki_topics_path
    end

    def index
      @topics = Wiki::Topic.all
    end

    def subscribe
      topic = Wiki::Topic.find(params[:topic_id])
      current_user.topic_subscriptions.find_or_create_by(topic: topic)
      redirect_to wiki_topics_path
    end

    private

    def topic_params
      params.require(:wiki_topic).permit(:name, :featured_image, :short_description)
    end

  end
end