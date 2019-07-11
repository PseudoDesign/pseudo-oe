CELESTIAL_PI4_BUILD_NAME = 'celestial-pi4-build'.freeze
CELESTIAL_PI4_IMAGE_NAME = 'core-image-base'.freeze

CELESTIAL_PI4_DOWNLOADS_DIR = File.join(__dir__, '..', 'downloads').freeze
CELESTIAL_PI4_SOURCES_DIR = File.join(__dir__, '..', 'sources').freeze
CELESTIAL_PI4_META_DIR = File.join(__dir__, 'meta').freeze
CELESTIAL_PI4_DEPLOY_DIR = File.join(__dir__, 'deploy').freeze
CELESTIAL_PI4_ARTIFACTS_DIR = File.join(__dir__, 'artifacts').freeze

desc "Build the #{CELESTIAL_PI4_IMAGE_NAME} image in #{CELESTIAL_PI4_BUILD_NAME}"
task :build_dev do
  Rake::Task['dev:build'].invoke(CELESTIAL_PI4_BUILD_NAME, CELESTIAL_PI4_IMAGE_NAME)
end

desc "Run the provided bitbake command string in the #{BUILD_NAME} context"
task :bitbake_dev, [:target] do |_task, args|
  Rake::Task['dev:build'].invoke(CELESTIAL_PI4_BUILD_NAME, args[:target])
end

desc "Build a #{CELESTIAL_PI4_BUILD_NAME} - #{CELESTIAL_PI4_IMAGE_NAME} release image"
task :release => ["docker:image"] do
  mkdir_f CELESTIAL_PI4_DOWNLOADS_DIR
  mkdir_f CELESTIAL_PI4_DEPLOY_DIR
  mkdir_f CELESTIAL_PI4_ARTIFACTS_DIR
  sh "docker run \
      -v #{__dir__}:/app/oe/build \
      -v #{CELESTIAL_PI4_SOURCES_DIR}:/app/oe/sources \
      -v #{CELESTIAL_PI4_META_DIR}:/app/meta \
      -v #{CELESTIAL_PI4_DOWNLOADS_DIR}:/app/oe/downloads \
      -v #{CELESTIAL_PI4_DEPLOY_DIR}:/mnt/deploy \
      -v #{CELESTIAL_PI4_ARTIFACTS_DIR}:/mnt/artifacts \
      #{DOCKER_IMAGE_NAME}"
end
