require 'erb'

# from http://www.stuartellis.name/articles/erb/


class SwiftViewModel
  include ERB::Util
  attr_accessor :className, :projectName, 
                :creatorName, :creationDate, 
                :properties, :functions

  def get_template()
    e = "no way"
    File.open(File.dirname(__FILE__) + "/swift_view_model.erb", "r") do |f|
      e = f.read()
      f.close()
    end
    return e
  end


  def initialize(className, projectName,
                creatorName, properties, 
                functions, creationDate = Time.now)
    @className = className
    @projectName = projectName
    @creatorName = creatorName
    @creationDate = creationDate 
    @properties = properties 
    @functions = functions 
    @template = get_template()
  end

  def render()
    ERB.new(@template, nil, '-').result(binding)
  end

  def save(file)
    File.open(file, "w+") do |f|
      f.write(render)
      f.close()
    end
  end
end