file = File.open("dffifo", "w")
file.sync = true

require 'io/console'

input_queue = Queue.new
output_queue = Queue.new

th1 = Thread.new { loop { input_queue << $stdin.getch } }
th2 = Thread.new { loop { 
  output = output_queue.pop
  puts "output is: #{output.inspect}"
  print "\r"
  
  file.print output
} }

output_mode = :normal

loop do

  input = input_queue.pop
  puts input.inspect
  print "\r"

  if input == ""
    if output_mode == :normal
      output_mode = :raw
    else
      output_mode = :normal
    end
  end

  if output_mode == :raw
    output_queue << input unless input == ""
  else
    if input == "\r"
      output_queue << input
    elsif input == ""
      output_queue << "\e"
    elsif input == "h"
      output_queue << "\eOD"
    elsif input == "j"
      output_queue << "\eOB"
    elsif input == "k"
      output_queue << "\eOA"
    elsif input == "l"
      output_queue << "\eOC"
    elsif input == "q"
      break
    end
  end
  
end



