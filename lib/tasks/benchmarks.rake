namespace :benchmarks do
  task :models => :environment do
    SpliceBenchmarks.profile
  end
end
