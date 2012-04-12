Factory.define :pivotal_gem_tracker_project, class: PivotalTracker::Project do |p|
  p.sequence(:id)
  p.sequence(:name) { |n| "Project Name #{n} from Tracker" }
end