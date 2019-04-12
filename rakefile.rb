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

    BUILD_DIR = File.join(__dir__, BUILD_NAME).freeze
    DOWNLOADS_DIR = File.join(__dir__, 'downloads')
    SOURCES_DIR = File.join(__dir__, 'sources').freeze
    META_DIR = File.join(BUILD_DIR, 'meta').freeze
    desc "Build a #{BUILD_NAME} - #{IMAGE_NAME} release image"
    task :release do
      sh "docker run \
          -v #{BUILD_DIR}:/app/oe/build \
          -v #{SOURCES_DIR}:/app/oe/sources \
          -v #{META_DIR}:/app/meta \
          -v #{DOWNLOADS_DIR}:/app/oe/downloads \
          -it #{DOCKER_IMAGE_NAME}"
    end
  end
end
