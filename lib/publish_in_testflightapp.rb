
require 'rubygems'
require 'active_resource'
require 'tmpdir.rb'

require File.dirname(__FILE__) + '/customField'
require File.dirname(__FILE__) + '/publishHelper'

require File.dirname(__FILE__) + '/redmine_resource'

STATUS_NEW = 1
STATUS_IN_PROGRESS = 2
STATUS_RESOLVED = 3
STATUS_FEEDBACK = 4

testflightappTokens = {"NSCoderZGZ" => "12434523523",
					   "Qeteo" => "2342342342233",
					   "GastroZGZ" => "32323244444"}

class Issue < RedmineResource
	def inProgress
		self.status_id = STATUS_IN_PROGRESS
		self.save
	end

	def close
		self.status_id = STATUS_RESOLVED
		self.save
	end

	def sendComment(message)
		self.notes = message
		self.status_id = STATUS_FEEDBACK
		self.save
	end
end

class User < RedmineResource
end

class Project < RedmineResource
end

# Find user by name

if ARGV[0].nil?
 puts "Must specify user name. Exiting"
 exit 
end

user = User.find(:first, :params => {:name => ARGV[0]})
puts "User id for " + user.login + ": " + user.id

puts '****************'

# Retrieving issues assigned to user with status NEW
issues = Issue.find(:all, :params => {:assigned_to_id => user.id, :status_id => STATUS_NEW})

issue = issues.first
unless issue.nil?
	puts "--------------------------"
	puts "Subject:" + issue.subject if !issue.subject.nil?
	puts "Desc:" + issue.description if !issue.description.nil?
	puts "Author:" +issue.author.name if !issue.author.nil?

	# Find TestFlight Team value
	project = Project.find(issue.project.id)
	puts "Project: " + project.name
	testFlightTeam = customField(project,"TestFlight Team")
	puts "TestFlight Team: " + testFlightTeam
	gitUrl = customField(project,"git url");
	puts "git url: " + gitUrl
	apiToken = customField(project, "API Token")
	puts "API Token: " + apiToken
	notes = customField(issue, "Notes")
	puts "Note: " + notes
	branch = customField(issue, "Branch")
	puts "Branch: " + branch
	teamToken = testflightappTokens[testFlightTeam]
	puts "Team Token: " + teamToken

	tmpDir = Dir.mktmpdir
	begin
		issue.inProgress	
		puts '--'
		downloadCodeFromGitServer(gitUrl, branch, tmpDir)
		buildProjectAndPublish(tmpDir,apiToken, teamToken)
		issue.close
	rescue Exception => e
		issue.sendComment("Error publishsing: " + e.message + " " + e.backtrace.inspect)
	end
	FileUtils.remove_entry tmpDir
end



