class Augment::Command
  def initialize(@name : String, @parser : Parser, &@block : ->)
    @args = Arguments.new(@parser)
    @flags = Flags.new(@parser)
  end
end

require "./command/arguments"
require "./command/flags"
