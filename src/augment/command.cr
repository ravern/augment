class Augment::Command
  @proxy = true

  getter args
  getter flags

  def initialize(@args : Array(String) = ARGV, @input : IO = STDIN, @output : IO = STDOUT, @error : IO = STDERR)
    @parser = Parser.new(@args)
  end

  def run
    command = @args.first

    with self yield

    if @proxy
      command = resolve(command)
      if command
        Process.exec(command, args: @args, input: @input, output: @output, error: @error)
      end
    end
  end

  # Resolves the path of a command, excluding paths that start with
  # `~/.augment/bin`.
  private def resolve(command : String) : String?
    dir = "#{ENV["HOME"]}/.augment"
    ENV["PATH"].split(':').each do |path|
      path = "#{path}/#{command}"
      if !path.starts_with?("#{dir}/bin") && File.executable?(path)
        return path
      end
    end
  end

  def command(name : String)
    if @args.size == 1
      return
    end

    command = @args[1]

    if name == command
      command = Command.new(@args.last(@args.size - 1), @input, @output, @error)
      command.run do
        with command yield
      end
    end
  end
end

require "./command/arguments"
require "./command/flags"
