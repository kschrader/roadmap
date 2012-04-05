class RefreshController < ApplicationController
  respond_to :html, :json
  before_filter :project

  def project
    @projects =Project.all
  end

  def refresh
  end

  def run_refresh
    tracker_project_id = params[:tracker_project_id]

    raise ArgumentError.new("Invalid argument.  Project ID required") unless tracker_project_id.present?
    raise ArgumentError.new("Invalid argument.  Token required") unless token.present?

    TrackerIntegration.update_project(tracker_project_id)
    flash[:notice] = 'Features fetched and updated.  Sorry for the wait.'
    redirect_to projects_path
  end

end