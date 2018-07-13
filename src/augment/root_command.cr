class Augment::RootCommand < Augment::Command
  # Stores the list of commands to be printed by the `list` command.
  @list : Array(String)?

  def initialize(args : Array(String) = ARGV, input : IO = STDIN, output : IO = STDOUT, error : IO = STDERR)
    if args.size == 1
      args << "help"
    end
    super("", 0, args, input, output, error)
  end

  def run
    if @parser.subcommand("help")
      help
      return
    end

    if @parser.subcommand("build")
      Builder.new(@input, @output, @error).build
      return
    end

    if @parser.subcommand("list")
      @list = [] of String
      @proxy = false
    end

    super do
      with self yield
    end

    list
  end

  def command(name : String)
    if list = @list
      list << name
    else
      path = resolve(name)
      if path
        if @parser.subcommand(name)
          command = Command.new("#{path}/#{name}", 1, @args, @input, @output, @error)
          command.run do
            with command yield
          end
        end
      else
        raise CommandNotFoundError.new(name)
      end
    end
  end

  private def list
    if list = @list
      list.each do |name|
        @output.puts name
      end
    end
  end

  private def help
    @output.puts "Usage:
    augment [command]

Commands:
    build    Rebuild the `augment` binary
    list     List the augmented commands
    help     Print usage and descriptions"
  end

  # Resolves the path of a command, excluding paths that start with
  # `~/.augment/bin`.
  private def resolve(command : String) : String?
    ENV["PATH"].split(':').each do |path|
      if !path.starts_with?("#{DIR}/bin") && File.executable?("#{path}/#{command}")
        return path
      end
    end
  end
end
