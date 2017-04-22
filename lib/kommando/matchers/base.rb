class Kommando::Matchers::Base
  attr_reader :nested_matchers
  
  def initialize(regexp, block)
    @regexp = regexp
    @block = block

    @nested_matchers = []
  end

  def match(string)
    raise "#match not implemented"
  end

  def call(match_data=nil)
    return unless @block
    @block.call match_data
  end

  def once(regexp, &block)
    m = Kommando::Matchers::Once.new regexp, block
    @nested_matchers << m
    m
  end

  def every(regexp, &block)
    m = Kommando::Matchers::Every.new regexp, block
    @nested_matchers << m
    m
  end
end