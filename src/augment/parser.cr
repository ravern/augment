class Augment::Parser
  # Returns the name of the command.
  getter command : String

  # Returns the arguments of the command.
  getter args : Array(String)

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
    if index = find_flag(name, short_name)
      return @args[index[0]]
    end
    return nil
  end

  # Sets the value of the flag with the given name.
  def set_flag(name : String, short_name : Char?, value : String)
    if index = find_flag(name, short_name)
      if index[1]
        @args[index[0]] = "--#{name}=#{value}"
      else
        @args[index[0]] = value
      end
    end
  end

  # Returns the index of the flag with the given name and a bool indicating
  # whether the flag is in the form `--flag=value`.
  private def find_flag(name : String, short_name : Char?) : Tuple(Int32, Bool)?
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

      if data["value"]?
        return {i, true}
      end

      if i + 1 < @args.size
        return {i + 1, false}
      end
    end

    return nil
  end
end
