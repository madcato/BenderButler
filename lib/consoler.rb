# From http://graysoftinc.com/terminal-tricks/random-access-terminal

require "io/console"

CSI = "\e["

# $stdout.write "#{CSI}2J"  # clear screen
# $stdout.write "#{CSI}1;1H"  # move to top left corner
# $stdout.write "#{CSI}s"   # save cursor position
# $stdout.write "#{CSI}u"   # restore save cursor position
# $stdout.write "#{CSI}1D"   # move back one character

# Reads keypresses from the user including 2 and 3 escape character sequences.
def read_char
  system("stty raw -echo")
  char = STDIN.read_nonblock(1) rescue nil
  system("stty -raw echo")
  return char
end

def printProgressBar(currentStep, position)
  rows, cols = STDIN.winsize
  barSize = cols - 2  # all minus [ and ]
  currentProgress = "=" * (currentStep*barSize)
  restProgress = " " * ((1-currentStep)*barSize)
  str = "[#{currentProgress}#{restProgress}]"
  $stdout.write position
  $stdout.write str
end

def printText(text, position)
  $stdout.write position
  $stdout.write text
end

def formatTime(totalSeconds)
  minutes = totalSeconds / 60
  seconds = totalSeconds % 60
  return "%02i:%02i" % [minutes, seconds]
end

def startProgessbar(seconds,title)
  startTime = Time.now

  printText("POMODORO: #{title}", "#{CSI}1;1H")


  currentTime = Time.new

  while (currentTime - startTime) < seconds
    currentTime = Time.new
    time = formatTime(currentTime - startTime)
    printText(time, "#{CSI}2;1H")
    printProgressBar((currentTime - startTime) / seconds, "#{CSI}3;1H")
    sleep(1)
    char = read_char()
    case char
    when "c"
      return false, 0
    when "f"
      return true, currentTime - startTime
    end
  end
  return true, currentTime - startTime
end
