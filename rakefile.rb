DOCKER_IMAGE_NAME = 'pseudo-oe'

desc "Remove all temporary (non-download) files"
task :clean_all do
  rm_rf 'tmp'
end

namespace :dev do
  RUN_SCRIPT = File.join(__dir__, 'scripts', 'oe-run')
  def bitbake(project, target)
    cmd = "#{RUN_SCRIPT} #{project} \"bitbake #{target}\""
    sh cmd
  end

  desc 'Build a local development image'
  task :build, [:environment, :target] do |_task, args|
    bitbake(args[:environment], args[:target])
  end
end

namespace :celestial do
  namespace :pi3 do
    require_relative 'celestial-pi3-build/rake-inc.rb'  
  end
end
