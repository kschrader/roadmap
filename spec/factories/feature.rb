Factory.define :feature do |f|
  f.sequence(:name) { |n| "FACTORY Feature #{n}" }
  f.story_type TrackerIntegration::StoryType::Feature
  f.description { "Some feature will do the thing." }
  f.estimate { 1 }
  f.labels { ["green", "black", "red"] }
end

Factory.define :bug, class: Feature do |f|
  f.sequence(:name) { |n| "FACTORY Bug #{n}" }
  f.story_type TrackerIntegration::StoryType::Bug
  f.description { "Fix the thing." }
  f.labels { ["green", "black", "red"] }
end