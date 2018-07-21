class Augment::Command::Flags
  def initialize(@parser : Parser)
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
  # `nil` is returned. For flags without values, see `get_bool`.
  def get(name : String, short_name : Char? = nil) : String?
    return @parser.get_flag(name, short_name)
  end
end
