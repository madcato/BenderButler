require File.dirname(__FILE__) + '/swift_view_model.rb'
require File.dirname(__FILE__) + '/c++.rb'

class BenderGenerator

  def self.resolve
    if ARGV.count < 2
      puts "Invalid number of arguments"
      puts " Sample: bender generate view_model Whisky ProjectName status:WhiskyStatus func:run\\(once:Bool\\)"
      exit -1
    end
    extras = ARGV
    extras.shift # generate
    generator = extras.shift
    className = extras.shift
    projectName = extras.shift
    properties = []
    functions = []
    extras.each do |arg|
      values = arg.split(':')
      if values[0] == 'func'
        values.shift
        functions << values.join(':')
      else 
        properties << { name: values[0], type: values[1]}
      end
    end
    
    if generator == "view_model"
      list = SwiftViewModel.new(className, 
                              projectName,
                              "Daniel Vela",
                              properties,
                              functions)
      fileName = File.join('./', className + "ViewModel.swift")
      if File.exists?(fileName)
        puts "File #{fileName} already exists. Delete it before running this script"
      else
        list.save(fileName)
      end
    end
    if generator == "c++"
      namespaces = className.split(":")
      className = namespaces.pop # remove last
      list = CPlusPlus.new(className, 
                           namespaces,
                           projectName,
                           "Daniel Vela",
                           properties,
                           functions)
      fileName = File.join('./', className )
      list.save(fileName)
    end
  end
end
