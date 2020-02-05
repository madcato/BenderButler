# make tmp dir
require 'tmpdir.rb'

dir = Dir.mktmpdir

puts dir

# begin
#   # use the directory...
#   open("#{dir}/foo", "w") { ... }
# ensure
#   # remove the directory.
#   FileUtils.remove_entry dir
# end