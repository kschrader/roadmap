task :cruise do
  ENV['METRICS_DIR'] = ENV['CC_BUILD_ARTIFACTS'] || 'tmp'

  sh "rake"
  # sh "rake cruise_production"
end

task :cruise_sandbox do
  cruise_target = "production"
  sep = '*'*20

  puts "#{sep} deploying #{cruise_target} #{sep}"
  sh "cap #{cruise_target} deploy"
end
