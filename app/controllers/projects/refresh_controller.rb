module Projects
  class RefreshController < ApplicationController
    respond_to :html, :json

    before_filter :project

    def refresh
    end

    def run_refresh
      token = params[:api_token]
      raise ArgumentError.new("Invalid argument.  Token required") unless token.present?

      TrackerIntegration.update_project(params[:api_token], @project.tracker_project_id)
      flash[:notice] = 'Features fetched and updated.  Sorry for the wait.'
      redirect_to project_path(@project)
    end

    protected

    def project
      @project = Project.find(params[:project_id])
    end

  end
end