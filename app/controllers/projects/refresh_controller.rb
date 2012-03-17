module Projects
  class RefreshController < ApplicationController
    respond_to :html, :json

    before_filter :project

    def refresh
    end

    def run_refresh
      TrackerIntegration.update_project(@project.tracker_project_id)
      flash[:notice] = 'Features fetched and updated.  Sorry for the wait.'
      redirect_to project_path(@project)
    end

    protected

    def project
      @project = Project.find(params[:project_id])
    end

  end
end