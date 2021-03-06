
$fileName = "./hooks/update"

$updateContent = <<~TEXT
#!/usr/bin/env ruby

$refname = ARGV[0]
$oldrev  = ARGV[1]
$newrev  = ARGV[2]
$user    = ENV['USER']

$project_running_dir = '%PROJECT_RUNNING_DIR1%'

puts "Launching gitlab-runner"
`ssh %REMOTE_MACHINE% -t "cd %PROJECT_RUNNING_DIR2% && /usr/local/bin/gitlab-runner exec shell build"`
TEXT

# yml \#{$refname} \#{$oldrev} \#{$newrev} \#{$user}

class BenderCi
  def self.run(command, remoteMachine, installDir)
    if command == "init" and !remoteMachine.nil? and !installDir.nil?
      if current_dir_bare_git?
        open($fileName, "w") do |file|
          $updateContent["%REMOTE_MACHINE%"] = remoteMachine
          $updateContent["%PROJECT_RUNNING_DIR1%"] = installDir
          $updateContent["%PROJECT_RUNNING_DIR2%"] = installDir
          file << $updateContent
          puts("#{$fileName} created.")
        end
      else
        puts("Error: current directory is not a bare git repository.")
      end
    elsif command == "remove"
      system("rm #{$fileName}")
      puts("#{$fileName} removed.")
    else
      puts("Usage: bender ci [init | remove] <remoteMachine> <installDir>")
    end
  end
  
  def self.current_dir_bare_git?
    bareDir = `git rev-parse --is-bare-repository`
    return bareDir
  end
end