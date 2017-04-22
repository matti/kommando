class Kommando; class Matcher
  attr_reader :nested_matchers
  def initialize(regexp, block)
    @regexp = regexp
    @block = block

    @nested_matchers = []
  end

  def match(string)
    string.match(@regexp)
  end

  def call(match_data=nil)
    return unless @block
    @block.call match_data
  end

  def once(regexp, &block)
    m = self.class.new regexp, block
    @nested_matchers << m
    m
  end
end; end