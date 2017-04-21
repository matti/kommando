class Kommando; class Stdin
  def initialize
    @buffer = []
  end

	def getc
    @buffer.shift
	end

	def <<(string)
    @buffer << string
	end

  def write(string)
    self << string
  end

  def writeln(string)
    self << string << "\r"
  end
end
end