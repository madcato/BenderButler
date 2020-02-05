#!/usr/bin/env ruby

require 'rbconfig'

def processor_count
    case RbConfig::CONFIG['host_os']
    when /darwin9/
      `hwprefs cpu_count`.to_i
    when /darwin/
      ((`which hwprefs` != '') ? `hwprefs thread_count` : `sysctl -n hw.ncpu`).to_i
    when /linux/
      `cat /proc/cpuinfo | grep processor | wc -l`.to_i
    when /freebsd/
      `sysctl -n hw.ncpu`.to_i
    when /mswin|mingw/
      require 'win32ole'
      wmi = WIN32OLE.connect("winmgmts://")
      cpu = wmi.ExecQuery("select NumberOfCores from Win32_Processor") # TODO count hyper-threaded in this
      cpu.to_enum.first.NumberOfCores
    end
end

puts processor_count()


/// Alternative

# $ gem install facter
# $ irb
# irb(main):001:0> require 'facter'
# => true
# irb(main):002:0> puts Facter.value('processors')['count']
# 4
# => nil
# irb(main):003:0>
#
#
# Source http://stackoverflow.com/questions/891537/detect-number-of-cpus-installed