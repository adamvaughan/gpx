desc "Deploy the master branch to the production server."
task :deploy do
  print "Deploying gpx to avaughan.com..."
  `ssh avaughan@avaughan.com /home/avaughan/rails_apps/gpx/deploy`
  puts "Done."
end
