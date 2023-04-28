require 'erb'

# from http://www.stuartellis.name/articles/erb/

class GeneratorClass
  include ERB::Util
  attr_accessor :className

  def initialize(template, className, argv)
    @className = className
    # iterate throug argv array with index
    argv.each_with_index do |arg, index|
        name = "argv" + index.to_s
        class << self; self; end.class_eval { attr_accessor name }
        send("#{name}=",arg)
    end
    @template = template
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