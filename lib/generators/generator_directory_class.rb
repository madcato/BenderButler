require 'erb'

# from http://www.stuartellis.name/articles/erb/

class GeneratorDirectoryClass
  include ERB::Util
  attr_accessor :className

  def initialize(className, argv)
    @className = className
    # iterate throug argv array with index
    argv.each_with_index do |arg, index|
        name = "argv" + index.to_s
        class << self; self; end.class_eval { attr_accessor name }
        send("#{name}=",arg)
    end
  end

  def render()
    ERB.new(@template, nil, '-').result(binding)
  end

  def process(template_dir)
    Dir.glob(File.join(template_dir, '*.erb')).each do |template_file|
        @template = File.read(template_file)
        output_file = File.join("#{@className}_#{File.basename(template_file, '.erb')}")
        save(output_file)
    end
  end

  def save(file)
    File.open(file, "w+") do |f|
      f.write(render)
      f.close()
    end
  end
end