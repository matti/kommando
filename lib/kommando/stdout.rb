class Kommando; class Stdout
  def initialize
    @buffer = []
  end

  def append(char)
    @buffer << char
  end

  def to_s
    @buffer.join ""
  end
end; end