class FeaturesController < ApplicationController
  include BilgePump::Controller

  model_scope [:project]
  model_class Feature

  def tagged
    @features = Feature.with_label(params[:value]).all
    render 'index' , project_id: @project.id
  end

  def schedule
    @feature = Feature.find(params[:feature_id])

    # create the story in tracker
    story = TrackerIntegration.create_feature_in_tracker(
      params[:api_token],
      params[:tracker_project_id],
      @feature
    )
    
    # set tracker id and save
    @feature.update(story)
    @feature.save

    redirect_to project_feature_path(@project, @feature)
  end

end