module TrackerIntegration
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
      # :owned_by,
      # :requested_by,
      # :story_type,
      # :taguri,
      # :url
    ]

    NumericFields = [
      :estimate,
      #:project_id
    ]

    ArrayFields = [
      :labels,
      # :tasks
    ]

    DateFields = [
      # :accepted_at,
      # :created_at
    ]
  end

  def self.update_project(token, project_id)
    PivotalTracker::Client.token = token
    project = PivotalTracker::Project.find(project_id)
    update_stories(project.stories.all)
  end

  def self.update_stories(stories)
    stories.each do |story|
      feature = Feature.find_by_story_id story.id
      feature ||= Feature.new
      feature.update(story).save
    end
  end

  def self.create_feature_in_tracker(token, project_id, feature)
    PivotalTracker::Client.token = token
    project = PivotalTracker::Project.find(project_id)
    create_story_for_project(project, feature)    
  end

  def self.create_story_for_project(project, feature)
    project.stories.create(name: feature.name, estimate: feature.estimate, labels: feature.labels, description: feature.description)
  end

end