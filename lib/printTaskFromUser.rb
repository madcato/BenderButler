
require 'rubygems'
require 'active_resource'
require File.dirname(__FILE__) + '/redmine_resource'

STATUS_NEW = 1
STATUS_IN_PROGRESS = 2
STATUS_RESOLVED = 3


class Issue < RedmineResource
  self.headers['X-Redmine-API-Key'] =
		redmineAdminAPIKEY()
end

class User < RedmineResource
  self.headers['X-Redmine-API-Key'] =
    redmineAdminAPIKEY()
end

# Find user by name

if ARGV[0].nil?
 puts "Must specify user name. Exiting"
 exit 
end

user = User.find(:first, :params => {:name => ARGV[0]})
puts "User id for " + user.login + ": " + user.id

puts '****************'

# Retrieving issues assigned to user
issues = Issue.find(:all, :params => {:assigned_to_id => user.id, :status_id => STATUS_NEW})

issues.each { |issue|
	puts "--------------------------"
	puts "Subject:" + issue.subject if !issue.subject.nil?
	puts "Desc:" + issue.description if !issue.description.nil?
	puts "Author:" +issue.author.name if !issue.author.nil?

	issue.status_id = STATUS_IN_PROGRESS
	issue.save
}


# Retrieving issues
 # issues = Issue.find(:all)
 # puts issues.first.subject

# Retrieving an issue
# issue = Issue.find(44134)
# puts issue.description
# puts issue.author.name


# Creating an issue
# issue = Issue.new(
#   :subject => 'REST API',
#   :assigned_to_id => 1,
#   :project_id => 1,
#   :custom_field_values => {'2' => 'Fixed'}
# )
# if issue.save
#   puts issue.id
# else
#   puts issue.errors.full_messages
# end

# # Updating an issue
# issue = Issue.find(1)
# issue.subject = 'REST API'
# issue.save

# # Deleting an issue
# issue = Issue.find(1)
# issue.destroy
