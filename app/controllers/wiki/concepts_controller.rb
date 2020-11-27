module Wiki
  class ConceptsController < ApplicationController

    skip_before_action :authenticate_user!, only: [:index, :show]

    before_action :set_app_title

    def new
      @topic = Wiki::Topic.find(params[:topic_id])
      @concept = @topic.concepts.build
    end

    def create
      @topic = Wiki::Topic.find(params[:topic_id])

      @concept = @topic.concepts.build(concept_params)
      @concept.created_by = current_user.id
      @concept.save
      redirect_to wiki_topic_concepts_path(@topic)
    end

    def index
      @topic = Wiki::Topic.find(params[:topic_id])
      @concepts = @topic.concepts.with_rich_text_content_and_embeds
    end

    def show
      @concept = Wiki::Concept.find(params[:id])
      @topic = @concept.topic
    end

    def learn
      concept = Wiki::Concept.find(params[:concept_id])
      current_user.concept_learnings.find_or_create_by(concept: concept)
      redirect_to wiki_topic_concept_path(concept.topic, concept)
    end

    private

    def concept_params
      params.require(:wiki_concept).permit(:title, :content, :featured_image, :short_description, :learning_time_minutes)
    end

    def set_app_title
      @app_title = 'Wiki'
    end
  end
end
