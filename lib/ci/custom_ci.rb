class CustomCI
  def self.resolve
    raise "Invalid number of arguments" if ARGV.count < 2
    $lane_done = false
    command = ARGV[1]
    bender_ci_file = File.join(Dir.pwd, ".bender-ci")
    if File.exists?(bender_ci_file)
      File.open(bender_ci_file, 'r') do |file|
        script = file.read
        # binding_obj = binding
        # binding_obj.local_variable_set(:object, CustomCIBuilder(command))
        # eval(script, binding_obj)
        eval(script)
        puts "Error: lane #{command} not found. Watch .bender-ci file" unless $lane_done
      end
    else
        puts "No CI file found"
    end
  end
end

# class CustomCIBuilder
#   include Singleton
#   def initialize(command)
#     @command = command
#   end
# end

def lane(name, &block)
  command = ARGV[1]
  if command == name.to_s
    puts "lane #{name}"
    $lane_done = true
    block.call
  end
end

def desc(description)
  puts "#{description}"
end

def build(args={})
  command_array = ["xcodebuild", "build"]
  command_array << args.map { |k, v| "-#{k} #{v}" }
  system(command_array.join(" "))
end

def test(args={})
  command_array = ["xcodebuild", "test"]
  command_array << args.map { |k, v| "-#{k} #{v}" }
  system(command_array.join(" "))
end

def archive(args={})
  puts "Archiving..."
  command_array = ["xcodebuild", "-archivePath ./build/app.xcarchive", "archive"]
  command_array << args.map { |k, v| "-#{k} #{v}" }
  result = system(command_array.join(" "))
  exit unless result
end

def export(args={})
  puts "Exporting..."
  command_array = ["xcodebuild", "-archivePath ./build/app.xcarchive", "-exportPath ./build", "-allowProvisioningUpdates", "-exportArchive"]
  command_array << args.map { |k, v| "-#{k} #{v}" }
  result = system(command_array.join(" "))
  exit unless result
end

def upload(args={})
  puts "Upload..."
  command_array = ["xcrun", "altool", "--upload-app", "-t ios", "-f ./build/*.ipa"]
  command_array << args.map { |k, v| "--#{k} #{v}" }
  result = system(command_array.join(" "))
  exit unless result
end