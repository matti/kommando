class Kommando::Buffer

  def initialize
    @buffer = []

    @matchers = {}
  end

  def append(string)
    @buffer << string
  end

  def to_s
    @buffer.join ""
  end

  def <<(string)
    @buffer << string
  end

  def write(string)
    self << string
  end

  def writeln(string)
    self.write "#{string}\r"
  end

  def getc
    @buffer.shift
  end

  def on(matcher, &block)
    @matchers[matcher] = block
  end
end
