class FeaturesController < ApplicationController
  include BilgePump::Controller
  respond_to :html, :json

  def refresh
    TrackerIntegration.update_project
    flash[:notice] = 'Features fetched and updated.  Sorry for the wait.'
    redirect_to features_path
  end

  def label
    @features = Feature.with_label(params[:value]).all
    render 'index'
  end
end
