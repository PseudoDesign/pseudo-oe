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
