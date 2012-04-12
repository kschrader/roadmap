class ProjectsController < ApplicationController
  include BilgePump::Controller
    before_filter :tracker_projects_not_in_roadmap, :only => [:index]

  protected
  def tracker_projects_not_in_roadmap 
    tracker_projects = PivotalTracker::Project.all
    roadmap_projects = Project.all

   @projects_not_in_roadmap = tracker_projects.reject do |tp|
      roadmap_projects.any? do |rmp|
        tp.id == rmp.tracker_project_id
      end
    end
  end
end