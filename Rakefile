require File.dirname(__FILE__) + '/lib/generators/generator.rb'

path = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
path = File.split(path)[0]

# task :default => :pomodoro

desc "Generate sample file. Arguments: file_name"
task :gen_sample, [:file_name] do |task_name, args|
  list = ShoppingList.new(get_items, get_template)
  list.save(File.join('./', args[:file_name]))
end

# desc "Indicate arguments as an array. Sample: `rake my_task[1,2]`"
# task :my_task, [:arg1, :arg2] do |task_name, args|
#   puts "Args were: #{args}"
#   puts "Task name is #{task_name}"
# end

desc "CI command. Argmuments ci <init|remove> <remote_machine> <install_path>"
task :ci, [:param] do |task_name, args|
  require path + "/lib/ci/bender_ci.rb"
  BenderCi.run(args.param[0], args.param[1], args.param[2])
end

# task :say_hello do
#   # ARGV contains the name of the rake task and all of the arguments.
#   # Remove/shift the first element, i.e. the task name.
#   ARGV.shift
#
#   # Use the arguments
#   puts 'Hello arguments:', ARGV
#
#   # By default, rake considers each 'argument' to be the name of an actual task.
#   # It will try to invoke each one as a task.  By dynamically defining a dummy
#   # task for every argument, we can prevent an exception from being thrown
#   # when rake inevitably doesn't find a defined task with that name.
#   ARGV.each do |arg|
#     task arg.to_sym do ; end
#   end
#
# end

desc "kebab case. Convert string to kebab case, removing special chars and tildes"
task :kebab, [:param] do |task_name, args|
  require path + '/lib/util/kebab.rb'
  text = args.param.join(" ")
  print text.to_s.kebabcase
end

desc "ios: build, test and deploy and iOS app"
task :ios, [:param] do |task_name, args|
  require path + "/lib/ci/custom_ci.rb"
  CustomCI.resolve(args.param)
end

desc "Generators"
task :generate, [:param] do |task_name, args|
  require path + "/lib/generators/bender_generator.rb"
  BenderGenerator.resolve()
end

Rake::TaskManager.record_task_metadata = true
desc "List tasks"
task :tasks do
  Rake.application.options.show_all_tasks = true
  Rake.application.options.show_tasks = :tasks  # this solves sidewaysmilk problem
  Rake.application.options.show_task_pattern = //
  Rake.application.options.full_description = true
  Rake.application.display_tasks_and_comments()
end