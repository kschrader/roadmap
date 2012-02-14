# Project-specific configuration for CruiseControl.rb

Project.configure do |project|

  # Send email notifications about broken and fixed builds to email1@your.site, email2@your.site (default: send to nobody)
  project.email_notifier.emails = ['development@flipstone.com']
  project.email_notifier.from = 'development@flipstone.com'

  project.build_command = %{bundle exec "unset RUBYOPT BUNDLE_GEMFILE GEM_HOME && cd /home/ubuntu/.cruise/projects/f2-qa/work && rvm 1.9.2 exec bundle install && rvm 1.9.2 exec bundle exec rake cruise"}
end