path = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
path = File.split(path)[0]

Rake::TaskManager.record_task_metadata = true

# task :default => :pomodoro

# desc "Indicate arguments as an array. Sample: `rake my_task[1,2]`"
# task :my_task, [:arg1, :arg2] do |task_name, args|
#   puts "Args were: #{args}"
#   puts "Task name is #{task_name}"
# end

desc "CI command, argmuments ci <init|remove> <remote_machine> <install_path>"
task :ci do
  require path + "/lib/bender_butler/commands/ci.rb"
  BenderButler::Commands::Ci.new.run
end

desc "Generators"
task :generate, [:param] do |task_name, args|
  require path + "/lib/generators/bender_generator.rb"
  BenderGenerator.resolve()
end

desc "List tasks"
task :tasks do
  Rake.application.options.show_all_tasks = true
  Rake.application.options.show_tasks = :tasks  # this solves sidewaysmilk problem
  Rake.application.options.show_task_pattern = //
  Rake.application.display_tasks_and_comments()
end
