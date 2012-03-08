Factory.define :bundle do |f|
  f.sequence(:name) { |n| "Feature Bundle #{n}"}
  f.project_id {
    (Factory :project).id
  }
end