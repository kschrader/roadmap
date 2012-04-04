module TrackerIntegration
  module StoryType
    Bug = "bug"
    Feature = "feature"
    Chore = "chore"
    Release = "release"
  end

  module Story
    StringFields = [
      # :attachments,
      :current_state,
      :description,
      # :integration_id,
      # :jira_id,
      # :jira_url,
      :name,
      # :notes,
      # :other_id,
      :owned_by,
      # :requested_by,
      :story_type
      # :taguri,
      # :url
    ]

    NumericFields = [
      :estimate
      #:project_id
    ]

    ArrayFields = [
      :labels
      # :tasks
    ]

    DateFields = [
      :accepted_at
      # :created_at
    ]
  end

  def self.update_project(tracker_project_id)
    tracker_project = PivotalTracker::Project.find(tracker_project_id)
    update_stories(tracker_project.stories.all,tracker_project)
  end

  def self.update_stories(stories, tracker_project)
    refresh_time = Time.now
    stories.each do |story|
      project = Project.find_by_tracker_project_id tracker_project.id
      project ||= Project.new
      project.tracker_project_id = tracker_project.id
      project.name = tracker_project.name
      project.refreshed_at = refresh_time
      project.save
      feature = Feature.find_by_story_id story.id
      feature ||= Feature.new
      feature.project_id = project.id
      feature.update(story, refresh_time).save
    end
      refresh_time_without_usec=refresh_time.change(:usec => 0)
      Feature.set({:tracker_project_id => tracker_project.id, refreshed_at: { :$lt => refresh_time_without_usec }}, :story_type => "Deleted")
  end

  def self.create_feature_in_tracker(tracker_project_id, feature)
    tracker_project = PivotalTracker::Project.find(tracker_project_id)
    create_story_for_project(tracker_project, feature)
  end

  def self.create_story_for_project(tracker_project, feature)
    tracker_project.stories.create(name: feature.name, estimate: feature.estimate, labels: feature.labels, description: feature.description)
  end

end