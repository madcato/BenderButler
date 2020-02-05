
def systemAndRaiseOnError(command)
	output = `#{command}`
	unless $?.success?
		raise SystemCallError.new(output)
	end
end

def downloadCodeFromGitServer(gitUrl,branch,tmpDir)
	systemAndRaiseOnError("git clone --branch #{branch} -- #{gitUrl} #{tmpDir} 2>&1")
end

def buildProjectAndPublish(tmpDir, apiToken, teamToken)
	systemAndRaiseOnError("cd #{tmpDir} && ipa build 2>&1 && ipa distribute:testflight -a #{apiToken} -T #{teamToken} 2>&1")
end 

def checkRedmineAPIKey(key)
  unless ENV.has_key?(key)
    abort("X#{key} enviromental variable not found")
  end
end

def loadRedmineAPIKEY(key)
  return ENV[key]
end

def redmineAPIKEY
  $KEY ||= loadRedmineAPIKEY("XRedmineAPIKey")
end

def redmineAdminAPIKEY
  $ADMINKEY ||= loadRedmineAPIKEY("XRedmineAdminAPIKey")
end
