DOCKER_IMAGE_NAME = 'pseudo-oe'

def mkdir_f(dir)
  mkdir dir unless File.directory?(dir)
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

namespace :docker do
  require_relative 'docker/rake-inc.rb'
end

#namespace :celestial do
#  namespace :pi3 do
#    require_relative 'celestial-pi3-build/rake-inc.rb'  
#  end
#end

namespace :toradex do
  namespace :apalis_imx6 do
    require_relative 'toradex-nxp-build/rake-inc.rb'
  end
end
