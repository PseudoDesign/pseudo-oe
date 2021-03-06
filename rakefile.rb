DOCKER_IMAGE_NAME = 'pseudo-oe'

def mkdir_f(dir)
  mkdir dir unless File.directory?(dir)
end

def increment_build_number(environment)
  temp_file = File.join(__dir__, environment, ".build-num")
  extras_file = File.join(__dir__, environment, ".extras.conf")
  if File.file?(temp_file)
    build_num = File.read(temp_file).to_i + 1
  else
    build_num = 0
  end
  `echo #{build_num} > #{temp_file}`
  `echo 'BSP_BUILD_NUMBER = "#{build_num}"' > #{extras_file}`
  branch_name = `git rev-parse --abbrev-ref HEAD`.gsub("\n", "")
  `echo 'BSP_VERSION = \"#{branch_name}\"' >> #{extras_file}`
end

namespace :dev do
  RUN_SCRIPT = File.join(__dir__, 'scripts', 'oe-run')
  def bitbake(project, target)
    priv_local = File.join(__dir__, project, "conf", "priv-local.conf")
    extras_file = File.join(__dir__, project, ".extras.conf")
    `cat #{priv_local} >> #{extras_file}`
    cmd = "#{RUN_SCRIPT} #{project} \"bitbake --postread=.extras.conf #{target}\""
    sh cmd
  end

  desc 'Build a local development image, eg "rake dev:build[celestial-pi0w-build,core-image-base]"'
  task :build, [:environment, :target] do |_task, args|
    increment_build_number(args[:environment])
    bitbake(args[:environment], args[:target])
  end
end

namespace :docker do
  require_relative 'docker/rake-inc.rb'
end

namespace :celestial do
  namespace :pi3 do
    require_relative 'celestial-pi3-build/rake-inc.rb'  
  end

  namespace :pi4 do
    require_relative 'celestial-pi4-build/rake-inc.rb'
  end

  namespace :pi0w do
    require_relative 'celestial-pi0w-build/rake-inc.rb'
  end
end

#namespace :toradex do
#  namespace :apalis_imx6 do
#    require_relative 'toradex-nxp-build/rake-inc.rb'
#  end
#end
