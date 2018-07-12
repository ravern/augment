class Augment::RootCommand < Augment::Command
  # Stores the list of commands to be printed by the `list` command.
  @list : Array(String)?

  def initialize(args : Array(String) = ARGV, input : IO = STDIN, output : IO = STDOUT, error : IO = STDERR)
    args.insert(0, "augment")
    if args.size == 1
      args << "help"
    end

    super("", args, input, output, error)
  end

  def run
    if @parser.subcommand("help")
      help
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
      super do
        with self yield
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
end
