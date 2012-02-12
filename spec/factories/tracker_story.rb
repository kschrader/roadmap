Factory.define :tracker_story, class: PivotalTracker::Story do |f|
  f.sequence(:id)
  f.sequence(:name) { |n| "Story Name #{n} from Tracker" }
  f.description "Description from Tracker"
  f.sequence(:url) { |n| "http://localhost/#{n}" }
  f.estimate 1
  f.labels "red, blue, green"
  f.current_state "unstarted"
  f.project_id 331770
  
    # element :created_at, DateTime
    # element :accepted_at, DateTime

    # element :name, String
    # element :description, String
    # element :story_type, String
    # element :estimate, Integer
    # element :requested_by, String
    # element :owned_by, String
    # element :labels, String
    # element :jira_id, Integer
    # element :jira_url, String
    # element :other_id, Integer
    # element :integration_id, Integer
    # element :deadline, DateTime # Only available for Release stories
end