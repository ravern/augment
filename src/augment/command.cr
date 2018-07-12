class Augment::Command
  @proxy = true

  getter args
  getter flags

  def initialize(@args : Array(String) = ARGV, @input : IO = STDIN, @output : IO = STDOUT, @error : IO = STDERR)
    @parser = Parser.new(@args)
  end

  def run
    command = @args.shift

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
  end
end

require "./command/arguments"
require "./command/flags"
