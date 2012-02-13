Factory.define :bundle do |f|
  f.sequence(:name) { |n| "Feature Bundle #{n}"}
end