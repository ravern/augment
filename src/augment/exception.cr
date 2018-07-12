module Augment
  class Exception < ::Exception
  end

  class BuildError < Exception
  end

  class CommandNotFoundError < Exception
    def initialize(command : String)
      super("command not found: #{command}")
    end
  end
end
