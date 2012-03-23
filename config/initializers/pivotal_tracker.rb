path = Rails.root.join("config/tracker_token")
if File.exists?(path)
  PivotalTracker::Client.token = File.read(path).strip
else
   $stderr.puts "You need to have a tracker_token file, check Readme"
end