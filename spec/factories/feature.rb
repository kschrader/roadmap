Factory.define :feature do |f|
  f.sequence(:name) { |n| "Feature #{n}" }
  f.description { "Some feature will do the thing." }
  f.size { 1 }
end