
$fileName = "./hooks/update"

$updateContent = <<~TEXT
#!/usr/bin/env ruby

$refname = ARGV[0]
$oldrev  = ARGV[1]
$newrev  = ARGV[2]
$user    = ENV['USER']

$project_running_dir = '%PROJECT_RUNNING_DIR%'

puts "Launching bender yml"
`ansible localhost -m shell -a "cd #{$project_running_dir} && bender yml #{$refname} #{$oldrev} #{$newrev} #{$user}`
TEXT

class BenderCi
  def self.run(command, installDir)
    if command == "init"
      if current_dir_bare_git?
        open($fileName, "w") do |file|
          $updateContent["%PROJECT_RUNNING_DIR%"] = installDir
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
      puts("Usage: bender ci [init | remove]")
    end
  end
  
  def self.current_dir_bare_git?
    bareDir = `git rev-parse --is-bare-repository`
    return bareDir
  end
end