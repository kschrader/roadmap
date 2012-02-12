class RefreshController < ApplicationController
  respond_to :html, :json

  def refresh
  end

  def run_refresh
    TrackerIntegration.update_project(params[:api_token], params[:project_id])
    flash[:notice] = 'Features fetched and updated.  Sorry for the wait.'
    redirect_to features_path
  end

end