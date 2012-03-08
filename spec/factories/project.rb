Factory.define :project do |f|
  f.sequence(:name) { |n| "FACTORY project #{n}" }
  f.tracker_project_id {1000}
end