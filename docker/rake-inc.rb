RAKEFILE_DIR = File.expand_path(File.dirname(__FILE__))
DOCKER_IMAGE = "pseudo-oe"
USERNAME = "oe-user"

desc "Build the ${DOCKER_IMAGE} image"
task :image do
  sh "docker build -t #{DOCKER_IMAGE} #{RAKEFILE_DIR}"
end

desc "Open a root-user shell into the ${DOCKER_IMAGE} image"
task :root_shell => [:image] do
  sh "docker run -it --privileged #{DOCKER_IMAGE} /bin/bash"
end

desc "Open a shell into the ${DOCKER_IMAGE} image as ${USERNAME}"
task :shell => [:image] do
  sh "docker run --user #{USERNAME} -it --privileged #{DOCKER_IMAGE} /bin/bash"
end
