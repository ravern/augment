# Represents the flags provided by the user.
#
# The following forms are supported:
#
# * `--flag value`
# * `--flag=value`
# * `--flag="value"`
# * `-f value`
# * `-abcf value`
class Augment::Command::Flags
  def initialize(@parser : Parser)
  end

  # Returns the value of the flag with the given name.
  #
  # If the flag is not found, or if the flag does not contain a value, then
  # `nil` is returned. For flags without values, see `get_bool`.
  def get(name : String, short_name : Char?) : String?
    return @parser.get_flag(name, short_name)
  end

  # Sets the value of the flag with the given name.
  #
  # If the flag is not found, a new flag is created immediately after the
  # command. For flags without values, see `set_bool`.
  def set(name : String, short_name : Char?, value : String)
    @parser.set_flag(name, short_name, value)
  end
end
