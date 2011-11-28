require 'stringio'

module Rapid

  # Output buffer for catching standard output
  class Buffer
    def initialize
      @stdout = $stdout
      out     = StringIO.new
      $stdout = out
    end

    # Ends buffering and returns the contents of the current buffer
    def out_clean
      out     = $stdout
      $stdout = @stdout
      out.string
    end
  end

  # Quick method to run something buffered with a block
  def Rapid.buffer(&block)
    buf = Buffer.new
    block.call
    buf.out_clean
  end
end