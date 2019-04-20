BUILD_NAME = 'celestial-pi3-build'.freeze
IMAGE_NAME = 'core-image-base'.freeze

DOWNLOADS_DIR = File.join(__dir__, '..', 'downloads').freeze
SOURCES_DIR = File.join(__dir__, '..', 'sources').freeze
META_DIR = File.join(__dir__, 'meta').freeze
DEPLOY_DIR = File.join(__dir__, 'deploy').freeze
ARTIFACTS_DIR = File.join(__dir__, 'artifacts').freeze

desc "Build the #{IMAGE_NAME} image in #{BUILD_NAME}"
task :build_dev do
  Rake::Task['dev:build'].invoke(BUILD_NAME, IMAGE_NAME)
end

desc "Run the provided bitbake command string in the #{BUILD_NAME} context"
task :bitbake_dev, [:target] do |_task, args|
  Rake::Task['dev:build'].invoke(BUILD_NAME, args[:target])
end

desc "Build a #{BUILD_NAME} - #{IMAGE_NAME} release image"
task :release => ["docker:image"] do
  mkdir_f DOWNLOADS_DIR
  mkdir_f DEPLOY_DIR
  mkdir_f ARTIFACTS_DIR
  sh "docker run \
      -v #{__dir__}:/app/oe/build \
      -v #{SOURCES_DIR}:/app/oe/sources \
      -v #{META_DIR}:/app/meta \
      -v #{DOWNLOADS_DIR}:/app/oe/downloads \
      -v #{DEPLOY_DIR}:/mnt/deploy \
      -v #{ARTIFACTS_DIR}:/mnt/artifacts \
      #{DOCKER_IMAGE_NAME}"
end
