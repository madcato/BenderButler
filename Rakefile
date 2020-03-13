require File.dirname(__FILE__) + '/lib/pomodoro'
require File.dirname(__FILE__) + '/lib/generators/generator.rb'

path = File.symlink?(__FILE__) ? File.readlink(__FILE__) : __FILE__
path = File.split(path)[0]

task :default => :pomodoro

desc "Start Pomodoro. Arguments: issue_id <comment>"
task :pomodoro, [:id, :comment] do |task_name, args|
  pomodoro(args[:id], args[:comment])
end


desc "Generate sample file. Arguments: file_name"
task :gen_sample, [:file_name] do |task_name, args|
  list = ShoppingList.new(get_items, get_template)
  list.save(File.join('./', args[:file_name]))
end

desc "Indicate arguments as an array. Sample: `rake my_task[1,2]`"
task :my_task, [:arg1, :arg2] do |task_name, args|
  puts "Args were: #{args}"
  puts "Task name is #{task_name}"
end

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