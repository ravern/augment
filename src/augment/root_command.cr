private class Augment::RootCommand < Augment::Command
  def initialize(args : Array(String), &@block : ->)
    super("", Parser.new(args), &block)
  end
end
