class RefreshController < ApplicationController
  respond_to :html, :json

  def refresh
  end

  def run_refresh
    tracker_project_id = params[:tracker_project_id]
    token = params[:api_token]
    project_id = params[:project_id]


    raise ArgumentError.new("Invalid argument.  Project ID required") unless tracker_project_id.present?
    raise ArgumentError.new("Invalid argument.  Token required") unless token.present?

    TrackerIntegration.update_project(params[:api_token], tracker_project_id, project_id)
    flash[:notice] = 'Features fetched and updated.  Sorry for the wait.'
    redirect_to features_path
  end

end