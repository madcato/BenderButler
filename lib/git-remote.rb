def remotize(project, server)
begin
    if project.nil?
      raise "<project> not specified"
    end
    if server.nil?
      raise "<server> not specified"
    end
  
    `git clone --bare ./#{project} #{project}.git`
    `scp -r #{project}.git #{server}:#{project}.git`
    `rm -rf #{project}.git`
    `cd #{project} && git remote add origin #{server}:#{project}.git && git push --set-upstream origin master`
  rescue StandardError => e 
    STDERR.puts("Error #{e.message}. Usage: remotize.rb <project> <server>")
  end
end