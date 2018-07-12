class Augment::Command
  # Whether to call the corresponding command after running the block.
  @proxy = true

  getter flags
  getter arguments

  def initialize(@command : String, @depth : Int32, @args : Array(String) = ARGV, @input : IO = STDIN, @output : IO = STDOUT, @error : IO = STDERR)
    @parser = Parser.new(@args.last(@args.size - @depth))
    @flags = Flags.new(@parser)
    @arguments = Arguments.new(@parser)
  end

  # Runs the command.
  def run
    with self yield

    if @proxy
      Process.exec(@command, args: @args.last(@args.size - 2), input: @input, output: @output, error: @error)
    end
  end

  # Creates a new child command and runs it if it matches.
  def command(name : String)
    if @parser.subcommand(name)
      command = Command.new(@command, @depth + 1, @args, @input, @output, @error)
      command.run do
        with command yield
      end
    end
  end
end

require "./command/arguments"
require "./command/flags"
