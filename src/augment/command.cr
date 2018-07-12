class Augment::Command
  # Whether to call the corresponding command after running the block.
  @proxy = true

  getter flags
  getter args

  def initialize(@command : String, args : Array(String), @input : IO = STDIN, @output : IO = STDOUT, @error : IO = STDERR)
    @parser = Parser.new(args)
    @flags = Flags.new(@parser)
    @args = Arguments.new(@parser)
  end

  # Runs the command.
  def run
    with self yield

    if @proxy
      Process.exit(0)
    end
  end

  # Creates a new child command and runs it if it matches.
  def command(name : String)
    if args = @parser.subcommand(name)
      command = Command.new(@command, args, @input, @output, @error)
      command.run do
        with command yield
      end
    end
  end

  # Resolves the path of a command, excluding paths that start with
  # `~/.augment/bin`.
  private def resolve(command : String) : String?
    dir = "#{ENV["HOME"]}/.augment"

    ENV["PATH"].split(':').each do |path|
      if !path.starts_with?("#{dir}/bin") && File.executable?("#{path}/#{command}")
        return path
      end
    end
  end
end

require "./command/arguments"
require "./command/flags"
