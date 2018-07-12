class Augment::RootCommand < Augment::Command
  # Stores the list of command names for use in `list` command.
  @list : Array(String)?

  def run
    if @args.empty?
      @args = ["build"]
    end

    command = @args.first

    case command
    when "build"
      Builder.new.build
      return
    when "list"
      @list = [] of String
    end

    super do
      with self yield
    end

    if list = @list
      list.each do |name|
        @output.puts name
      end
    end
  end

  def command(name : String)
    if list = @list
      list << name
    else
      super
    end
  end
end
