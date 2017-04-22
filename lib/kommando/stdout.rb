class Kommando; class Stdout
  def initialize(shell)
    @buffer = []
    @matchers = []
    @matcher_buffer = ""

    @shell = shell
  end

  def <<(c)
    @buffer << c
    @matcher_buffer << c

    matchers_copy = @matchers.clone # blocks can insert to @matchers while iteration is undergoing
    matchers_copy.each do |matcher|
      if matcher.match @matcher_buffer
        matcher.call
        @matchers.delete matcher  #TODO: is this safe?
        @matchers = @matchers + matcher.nested_matchers #TODO: is this safe?
      end
    end
  end

  def to_s
    string = @buffer.join ""

    #TODO: this behaviour maybe makes no sense?
    string.strip! if @shell

    matchers = @matchers
    #TODO: deprecate .on
    string.define_singleton_method(:on) do |regexp, &block|
      m = Kommando::Matcher.new regexp, block
      matchers << m
      m
    end

    string.define_singleton_method(:once) do |regexp, &block|
      m = Kommando::Matcher.new regexp, block
      matchers << m
      m
    end

    string
  end

end; end