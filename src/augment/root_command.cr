class Augment::RootCommand < Augment::Command
  # Stores the list of command names for use in `list` command.
  @list : Array(String)?

  def run
    @args.insert(0, "augment")

    if @args.size == 1
      @args << "help"
    end

    case @args[1]
    when "help"
      help
      return
    when "build"
      Builder.new.build
      return
    when "list"
      @list = [] of String
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
