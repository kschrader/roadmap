path = Rails.root.join("config/tracker_token")
if Rails.env.test?
  $stdout.puts "tracker_token file does NOT load in test env"
else
  if File.exists?(path)
    PivotalTracker::Client.token = File.read(path).strip
  else
     $stderr.puts "You need to have a tracker_token file, check Readme"
  end
end