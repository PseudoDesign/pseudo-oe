namespace :dev do
  RUN_SCRIPT = File.join(__dir__, 'scripts', 'oe-run')
  def bitbake(project, image)
    cmd = "#{RUN_SCRIPT} #{project} \"bitbake #{image}\""
    sh cmd
  end

  desc 'Build a local development image'
  task :build, [:environment, :image] do |_task, args|
    bitbake(args[:environment], args[:image])
  end
end

namespace :celestial do
  namespace :pi3 do
    BUILD_NAME = 'celestial-pi3-build'.freeze
    IMAGE_NAME = 'rpi-basic-image'.freeze
    desc "Build the #{IMAGE_NAME} image in #{BUILD_NAME}"
    task :build do
      Rake::Task['dev:build'].invoke(IMAGE_NAME, BUILD_NAME)
    end
  end
end
