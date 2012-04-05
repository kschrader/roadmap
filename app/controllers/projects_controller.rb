class ProjectsController < ApplicationController
  include BilgePump::Controller
  before_filter :tracker_projects

  def tracker_projects
    @tracker_projects = PivotalTracker::Project.all
  end

end