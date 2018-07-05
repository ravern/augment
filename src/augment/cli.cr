require "../augment"

module Augment
  class CLI
    def initialize(@args : Array(String) = ARGV, @input : IO = STDIN, @output : IO = STDOUT, @error : IO = STDERR)
    end

    def run
      @output.puts @args
    end
  end
end

Augment::CLI.new.run
