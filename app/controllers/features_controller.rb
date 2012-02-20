class FeaturesController < ApplicationController
  include BilgePump::Controller

  def tagged
    @features = Feature.with_label(params[:value]).all
    render 'index'
  end

  def run_schedule
    @feature = Feature.find(params[:feature_id])

    # create the story in tracker
    story = TrackerIntegration.create_feature_in_tracker(
      params[:api_token],
      params[:project_id],
      @feature
    )
    
    # set tracker id and save
    @feature.update(story)
    @feature.save

    redirect_to feature_path(@feature)
  end

end