Factory.define :feature do |f|
  f.sequence(:name) { |n| "FACTORY Feature #{n}" }
  f.description { "Some feature will do the thing." }
  f.estimate { 1 }
  f.labels { ["green", "black", "red"] }
end