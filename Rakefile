task :default => :build

desc "Build site using Jekyll"
task :build do
  sh "jekyll build"
end

desc "Deploy to Dev"
task :deploy => :"deploy:dev"

namespace :deploy do
  desc "Deploy to Dev"
  task :dev => :build do
    sh "rsync -rtz --delete _site/ digitalslovakia.org@digitalslovakia.org:/sub/dev/"
  end
  
  desc "Deploy to Live"
  task :live => :build do
    sh "rsync -rtz --delete _site/ digitalslovakia.org@digitalslovakia.org:/web/"
  end
  
  desc "Deploy to Dev and Live"
  task :all => [:dev, :live]
end
