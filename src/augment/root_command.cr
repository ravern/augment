class Augment::RootCommand < Augment::Command
  # Stores the list of commands to be printed by the `list` command.
  @list : Array(String)?

  # Whether to augment command by yielding
  @augment = true

  def initialize(args : Array(String) = ARGV, input : IO = STDIN, output : IO = STDOUT, error : IO = STDERR)
    if args.size == 1
      args << "help"
    end
    super("", 0, args, input, output, error)
  end

  def run
    case @parser
    when .has_subcommand?("help")
      help
      return
    when .has_subcommand?("build")
      Builder.new(@input, @output, @error).build
      return
    when .has_subcommand?("list")
      @list = [] of String
      @proxy = false
    when .has_subcommand?("with")
      @args.shift
      @parser = Parser.new(@args)
    when .has_subcommand?("without")
      @args.shift
      @parser = Parser.new(@args)
      @augment = false
    else
      help
      return
    end

    with self yield

    if @list
      list
    end
  end

  def command(name : String)
    if list = @list
      list << name
    else
      path = resolve(name)
      if path
        # Code is repeated from `Command` due to the way blocks work
        if @parser.has_subcommand?(name)
          command = Command.new("#{path}/#{name}", 1, @args, @input, @output, @error)
          command.run do
            if @augment
              with command yield
            end
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
    help     Print usage and descriptions
    with     Runs the command with augments
    without  Runs the command without augments"
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
