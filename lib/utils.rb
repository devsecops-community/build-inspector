require 'open3'
require 'rainbow'

module Utils
  # Because "puts `cmd`" doesn't stream the output as it appears
  def self.exec_puts(command)
    Open3.popen3(command) do |stdin, stdout, stderr, thread|
      # read each stream from a new thread
      { :out => stdout, :err => stderr }.each do |type, stream|
        Thread.new do
          until (line = stream.gets).nil? do
            case type
            when :out
              puts "==> inspector: #{line}"
            when :err
              print "==> inspector: #{Rainbow(line).red}"
            end
          end
        end
      end
      thread.join
    end
  end

  def self.timestamp
    Time.now.strftime('%Y%m%d%H%M%S')
  end

  def self.yellowify(text)
    Rainbow(text).yellow.bright
  end

  def self.yell(text)
    "echo #{yellowify(text)}"
  end
end
