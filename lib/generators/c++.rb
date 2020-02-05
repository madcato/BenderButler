require 'erb'

# from http://www.stuartellis.name/articles/erb/


class CPlusPlus
  include ERB::Util
  attr_accessor :className, :projectName, 
                :creatorName, :creationDate, 
                :properties, :functions

  def get_template(filePath)
    e = "no way"
    File.open(File.dirname(__FILE__) + filePath, "r") do |f|
      e = f.read()
      f.close()
    end
    return e
  end

  def addBeginNamespaces
    str = ""
    @namespaces.each { |namespace|
      str = str + "namespace #{namespace} {\n"
    }
    return str
  end

  def addEndNamespaces
    str = ""
    @namespaces.reverse.each { |namespace|
      str = str + "}  // namespace #{namespace}\n"
    }
    return str    
  end
  
  def initialize(className, namespaces,
                projectName,
                creatorName, properties, 
                functions, creationDate = Time.now) # Namespcase is an array: ["namespace1", "namespace2"]
    @className = className
    @projectName = projectName
    @namespaces = namespaces
    @creatorName = creatorName
    @creationDate = creationDate 
    @properties = properties 
    @functions = functions 
    @template_cpp = get_template("/c++_cpp.erb")
    @template_h = get_template("/c++_h.erb")
    @define = ""
    @path = ""
    @namespaces.each { |namespace|
      @define = @define + "#{namespace}_".upcase
      @path = @path + "#{namespace}/"
    }
    @define = @define + "#{className}_H_".upcase     # sample: AAI_NNA_NEURONALNETWORKDYNAMICARRAY_H_
    print "For C++ use format namespace1:namespace2:ClassName to indicate namespaces\n"
  end

  def render_cpp()
    ERB.new(@template_cpp, nil, '-').result(binding)
  end

  def render_h()
    ERB.new(@template_h, nil, '-').result(binding)
  end

  def save(file)
    if File.exists?(file + ".cpp")
      puts "File #{file + ".cpp"} already exists. Delete it before running this script\n"
    elsif File.exists?(file + ".h")
      puts "File #{file + ".h"} already exists. Delete it before running this script\n"
    else
      File.open(file + ".cpp", "w+") do |f|
        f.write(render_cpp)
        f.close()
      end
      File.open(file + ".h", "w+") do |f|
        f.write(render_h)
        f.close()
      end
    end
  end
end
