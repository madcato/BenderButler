require 'yaml' # STEP ONE, REQUIRE YAML!
# Parse a YAML string
YAML.load("--- foo") #=> "foo"

# Emit some YAML
YAML.dump("foo")     # => "--- foo\n...\n"
{ :a => 'b'}.to_yaml  # => "---\n:a: b\n"

str = <<-FOO
- 
  name: Daniel Vela
  age: 40
-
  name: Asdgfjl asdfkk
  age: 50
-
  name: Edfg ada
  age: 23  
FOO

p YAML.load(str)

str2 = <<-FOO
- 
  - Daniel Vela
  - 40
-
  - Asdgfjl asdfkk
  - 50
-
  - Edfg ada
  - 23  
FOO

p YAML.load(str2)

str3 = <<-FOO
default: &default
  - Daniel Vela
  - 40
development:
  - *default
  - Asdgfjl asdfkk
  - 50
production:
  - Edfg ada
  - 23  
FOO

p YAML.load(str3)


str4 = %q(
functions:
  - name: prueba
    params:
      - run: Int
      - name: String
  - name: cosa
    params:
      - tromba: Bool
)

p YAML.load(str4)