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

  # Returns the value of the flag with the given name.
  #
  # The following forms are supported:
  #
  # * `--flag value`
  # * `--flag=value`
  # * `--flag="value"`
  # * `-f value`
  # * `-abcf value`
  #
  # If the flag is not found, or if the flag does not contain a value, then
  # `nil` is returned. For flags without values, see `get_bool_flag`.
  def get_flag(name : String, short_name : Char? = nil) : String?
    name_regex = Regex.new("^--#{name}(?:=(?<value>.+))?$")
    short_name_regex = Regex.new("^-[a-zA-Z]*#{short_name}$")

    @args.each_with_index do |arg, i|
      data = name_regex.match(arg)
      unless data
        data = short_name_regex.match(arg)
      end
      unless data
        next
      end

      if value = data["value"]?
        return value
      end

      if i + 1 < @args.size
        return @args[i + 1]
      end
    end

    return nil
  end
end
