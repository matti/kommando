class Kommando; class EveryMatcher < Kommando::Matcher
  def initialize(regexp, block)
    @cursor = 0
    super regexp, block
  end

  def match(string)
    did_match = super string[@cursor..-1]
    @cursor = string.length if did_match
#    puts  "matching '#{@regexp}' from '#{string}' skipping #{@cursor} (#{did_match})"
    did_match
  end

  def every(regexp, &block)
    m = self.class.new regexp, block
    @nested_matchers << m
    m
  end

  def skip_with(string)
    @cursor = string.length
  end

end; end