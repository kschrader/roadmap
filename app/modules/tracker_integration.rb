module TrackerIntegration
  module Story
    StringFields = [
      # :attachments, 
      # :current_state,
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
end