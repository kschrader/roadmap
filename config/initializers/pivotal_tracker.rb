path = Rails.root.join("config/tracker_token")
PivotalTracker::Client.token = File.read(path).strip
