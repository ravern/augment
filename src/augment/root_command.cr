class Augment::RootCommand < Augment::Command
  def run
    if @args[0] == "list"
      @block.call
    else
      command = @args.shift
      Process.exec("/usr/bin/#{command}", @args, input: @input, output: @output, error: @error)
    end
  end
end
