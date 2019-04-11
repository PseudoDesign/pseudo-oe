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
    BUILD_NAME = 'celestial-pi3-build'.freeze
    IMAGE_NAME = 'rpi-basic-image'.freeze
    desc "Build the #{IMAGE_NAME} image in #{BUILD_NAME}"
    task :build_dev do
      Rake::Task['dev:build'].invoke(BUILD_NAME, IMAGE_NAME)
    end

    desc "Run the provided bitbake command string in the #{BUILD_NAME} context"
    task :bitbake_dev, [:target] do |_task, args|
      Rake::Task['dev:build'].invoke(BUILD_NAME, args[:target])
    end

    desc "Build a #{BUILD_NAME} - #{IMAGE_NAME} release image"
    task :release do

    end
  end
end
