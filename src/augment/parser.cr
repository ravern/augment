class Augment::Parser
  # Returns the name of the command.
  getter command : String

  # Parses the given arguments.
  #
  # The first argument should be the name of the command. Therefore, the given
  # arguments should never be empty, or an `ArgumentError` will be raised.
  def initialize(@args : Array(String))
    if @args.empty?
      raise ArgumentError.new("Must provide at least one argument (command name)")
    end

    @command = @args.first
  end

  # Returns whether a subcommand with the given name exists.
  #
  # For example, in `augment build -v`, the child command would be `build`.
  def subcommand(name : String) : Bool
    return @args.size > 1 && @args[1] == name
  end
end
