
module ActiveRecord
  VALID_FIELDS = {
    binary: "invalid",
    boolean: "Bool",
    date: "Date",
    datetime: "Date",
    decimal: "Decima",
    float: "Float",
    integer: "Int",
    primary_key: "invalid",
    string: "String",
    text: "String",
    time: "Date",
    timestamp: "Date"
  }

  @@version = "none"

  def self.setVersion(value)
    @@version = value
  end

  def self.version
    @@version
  end

  class Table
    include ERB::Util

    def initialize(table_name)
      @table_name = table_name
      @fields = []
    end

    def method_missing(m, *args, &block)
      type = ActiveRecord::VALID_FIELDS[m]
      return if type.nil?
      if type == "invalid"
        print("Invalid type: #{m.inspect}, args: #{args.inspect}")
        exit()
      end
      optional = ""
      optional = "?" if args[1].nil? == false && args[1][:null] == true
      @fields.append({field_name: args[0], field_tpye: "#{type}#{optional}"})
    end

    def save_file
      file_name = @table_name + ".swift"
      @version = ActiveRecord.version
      @class_name = @table_name.capitalize
      @properties = @fields.map do |field|
        { name: field[:field_name].camelcase(:lower), original_name: field[:field_name], type: field[:field_tpye] } 
      end

      save(file_name)
    end

    def render
      ERB.new(get_template(), nil, '-').result(binding)
    end

    def get_template()
      e = "no way"
      File.open(File.dirname(__FILE__) + "/codable.erb", "r") do |f|
        e = f.read()
        f.close()
      end
      return e
    end

    def save(file)
      File.open(file, "w+") do |f|
        f.write(render)
        f.close()
      end
    end
  end

  class Schema
    def Schema.define(version, *block)
      ActiveRecord.setVersion(version[:version])
      yield()
    end 
  end
end

def create_table(table_name, params, *block)
  table = ActiveRecord::Table.new(table_name)
  yield(table)
  table.save_file
end

def add_foreign_key(val1, val2)
end

def execute_ror_scheme(scheme_file)
  load(scheme_file)
end