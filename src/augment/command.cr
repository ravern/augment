class Augment::Command
  getter args
  getter flags

  def initialize(@args : Array(String) = ARGV, @input : IO = STDIN, @output : IO = STDOUT, @error : IO = STDERR, &@block : ->)
    @parser = Parser.new(@args)
  end

  def run
  end

  def command(name : String)
  end
end

require "./command/arguments"
require "./command/flags"
