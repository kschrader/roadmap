if File.exists?("config/tracker_token")
  path = Rails.root.join("config/tracker_token")
  PivotalTracker::Client.token = File.read(path).strip
else
  puts "You need to have a tracker_token file, check Readme"
end