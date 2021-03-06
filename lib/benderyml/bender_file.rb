require 'yaml'
require 'open3'
require 'net/smtp'
require 'tempfile'
# require 'octokit'

class BenderFile
  def run
    ymlFile = ".bender.yml"
    if File.exists?(ymlFile)
      process ymlFile
    else
      abort("#{ymlFile} file not found")
    end
  end

  def process(ymlFile)
    config = YAML.load_file(ymlFile)
    makePhase("script", config)
  end

  def makePhase(phase, config)
    commands = config[phase]
    execute commands, phase, config
  end
  
  def execute(commands, phase, config)
    return if commands.nil?
    commands.each do |command|
      shell command, phase, config
    end
  end
  
  def shell(command, phase, config)
    stdout, stderr, status = Open3.capture3(command)
    puts stdout
    puts stderr
    if status.exitstatus != 0 and phase == "script"
      message = "\#\# #{command} in phase #{phase} failed\n\n\n```#{stderr}\n\n```"
      sendM(message, false, config)
      makePhase("after_failure", config)
    else
      if phase == "script"
        makePhase("after_script", config) 
        message = "Build ok\n\n\n```#{stdout}\n\n```"
        sendM(message, true, config)
      end
    end
  end
  
  # def send(message,config)
  #   repository = config['repository']
  #   if repository.nil?
  #     puts message
  #   else
  #     # Provide authentication credentials
  #     Octokit.configure do |c|
  #       c.login = ENV["GITHUB_LOGIN"]
  #       c.password = ENV["GITHUB_PASSWORD"]
  #     end
  #     Octokit.create_issue repository, "Bender failure", message
  #   end
  # end
  
  def sendM(message, finished_ok, config)
    to = config['config']['to']
    subject = finished_ok ? config['config']['subject_ok'] : config['config']['subject_bad']
    from = config['config']['from']
    send(to, from, subject, message)
  end

  def send(to, from, subject, message)
    body = <<EOF
From: #{from}
To: #{to}
Subject: #{subject}

#{message}
EOF
    file = Tempfile.new('bender_send_mail')
    file.write(body)
    file.close()
    system("sendmail -f #{to} #{to} < #{file.path}")
    file.unlink
  end
end

# require 'octokit'
#
# # Provide authentication credentials
# Octokit.configure do |c|
#   c.login = 'xxxxxxxxx@xx.com'
#   c.password = 'password'
# end
#
# # Doc https://github.com/octokit/octokit.rb/blob/master/lib/octokit/client/issues.rb
#
# # # Fetch the current user
# # p Octokit.user
#
# # # Add a commnet to an issue
# # issues = Octokit.add_comment 'madcato/LongPomo', 20, "Prueba de comentario"
# # p issues
#
# # Create an issue
# issues = Octokit.create_issue 'madcato/LongPomo', "Prueba de issue", "asdfasdfasdgagasdgassdg"
# p issues


## Send mail smtp gmail
#
#   def send(message)
#     send('xxxxxxx@xx.com', 'Prueba script', message)
#     # system("echo #{message} | mail -s 'Bender task failed' xxxxxxx@xx.com")
#   end
#   SMTPHOST = "smtp.gmail.com"
#   FROM = '"Bender" <veladan@gmail.com>'
#
#   def send(to, subject, message)
#     body = <<EOF
# From: #{FROM}
# To: #{to}
# Subject: #{subject}
#
# #{message}
# EOF
#
#     # Net::SMTP.start(SMTPHOST, 587, 'gmail.com', 'veladan@gmail.com', 'password', :plain) do |smtp|
# #       smtp.enable_starttls
# #       smtp.send_message body, FROM, to
# #     end
#
#     smtp = Net::SMTP.new 'smtp.gmail.com', 587
#     smtp.enable_starttls
#     smtp.start('gmail.com', 'veladan@gmail.com', 'password', :login) do
#       smtp.send_message(msg, FROM, to)
#     end
#   end


