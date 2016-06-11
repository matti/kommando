class Kommando::Buffer

  def initialize
    @buffer = []
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

  def getc
    @buffer.shift
  end
end
