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
  # For example, in `augment build -v`, the subcommand would be `build`.
  def has_subcommand?(name : String) : Bool
    return @args.size > 1 && @args[1] == name
  end

  # Returns the value of the flag with the given name.
  def get_flag(name : String, short_name : Char?) : String?
    name_regex = Regex.new("^--#{name}(?:=(?<value>.+))?$")
    if short_name
      short_name_regex = Regex.new("^-[a-zA-Z]*#{short_name}$")
    end

    @args.each_with_index do |arg, i|
      data = name_regex.match(arg)
      if !data && short_name_regex
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
