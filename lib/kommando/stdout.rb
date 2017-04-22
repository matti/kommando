class Kommando; class Stdout
  def initialize(shell)
    @buffer = []
    @matchers = {}
    @matcher_buffer = ""

    @shell = shell
  end

  def <<(c)
    @buffer << c
    @matcher_buffer << c

    matchers_copy = @matchers.clone # blocks can insert to @matchers while iteration is undergoing
    matchers_copy.each_pair do |matcher,block|
      if @matcher_buffer.match matcher
        block.call
        @matchers.delete matcher # do not match again  TODO: is this safe?
      end
    end
  end

  def to_s
    string = @buffer.join ""

    #TODO: this behaviour maybe makes no sense?
    string.strip! if @shell

    matchers = @matchers
    string.define_singleton_method(:on) do |matcher, &block|
      matchers[matcher] = block
    end

    string
  end

end; end