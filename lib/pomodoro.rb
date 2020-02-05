
require 'rubygems'
require 'active_resource'

require File.dirname(__FILE__) + '/redmine_resource'

# require 'terminal-notifier'
require File.dirname(__FILE__) + '/consoler.rb'

class Issue < RedmineResource
end

class TimeEntry < RedmineResource
end

minutes = 52

def pomodoro(id, comment=nil)
  if id.nil?
   puts "Must specify issue id. Exiting"
   exit 
  end


  puts '****************'

  # Retrieving issue
  issue = Issue.find(id)

  puts issue.subject
  puts ""
  puts "Press f to complete the pomodoro. Press c to cancel pomodoro."


  puts "Waiting #{minutes} minutes"

  completed, timeSpent = startProgessbar(minutes*60,issue.subject)
  if completed
    TerminalNotifier.notify('Pomodoro', :title => issue.subject, :subtitle => "#{minutes} minutes ended")

    puts 'Creating time entry in server'
    # Creating a time entry
    params = {issue_id: issue.id,
              hours: timeSpent / 3600,
              acdtivity_id: 9}
    params[:comments] = comment unless comment.nil?
    time_entry = TimeEntry.new(params)

    if time_entry.save
      puts time_entry.id
      puts "OK. Exiting"
    else
      puts time_entry.errors.full_messages
    end
  end
end