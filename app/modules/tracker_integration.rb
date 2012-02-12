module TrackerIntegration
  module Story
    StringFields = [
      # :attachments, 
      :current_state,
      :description,
      :id,
      # :integration_id,
      # :jira_id,
      # :jira_url,
      :name,
      # :notes,
      # :other_id,
      # :owned_by,
      # :project_id,
      # :requested_by,
      # :story_type,
      # :taguri,
      # :url
    ]

    NumericFields = [
      :estimate
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
      feature = Feature.find_by_id story.id
      feature ||= Feature.new
      feature.update(story).save
    end
  end

end