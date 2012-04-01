=begin
 monitor.rb
 Visit the internets for documentation, updates and examples.
 https://github.com/pwhisenhunt/

 Author: Phillip J. Whisenhunt phillip.whisenhunt@gmail.com http://phillipwhisenhunt.com
 
 Permission is hereby granted, free of charge, to any person
 obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without
 restriction, including without limitation the rights to use,
 copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following
 conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 OTHER DEALINGS IN THE SOFTWARE.
=end

total_mb = 0
IO.popen('sysctl hw.memsize') do |output|
  output.each do |line|
    total_mb = line.split(" ")[1].to_f / 1000000.0
  end
end

processes = ARGV[0].gsub(/\s+/, "").split(",")
memory_size = ARGV[1].to_f

puts "#{ total_mb } MB discovered."
puts "Monitoring for processes that exceed #{memory_size} MB."
puts "------------------------------------------------"
puts "time\tprocess\tpid\t% memory\tmessage"
puts "------------------------------------------------"
while true
  IO.popen('ps aux') do |output|
    output.each do |line|
      data = line.split(" ")
      for process in processes
        if line.include? process and (data[3].to_f / 10) * total_mb > memory_size
          puts "#{ Time.now }\tprocess\t#{ data[1] }\t#{ data[3] }%"
          begin
            Process.kill(9, data[1].to_i)
            puts "#{ Time.now }\tprocess\t#{ data[1] }\t#{ data[3] }%\tProcess successfully killed."
            puts "------------------------------------------------"
            true
          rescue
            puts "#{ Time.now }\tprocess\t#{ data[1] }\t#{ data[3] }%\tError killing the process."
            puts "------------------------------------------------"
            false
          end
        end
      end
    end
  end
end