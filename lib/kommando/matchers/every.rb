class Kommando::Matchers::Every < Kommando::Matchers::Base
  def initialize(regexp, block)
    super regexp, block
    @cursor = 0
  end

  def match(string)
    match_data = string[@cursor..-1].match(@regexp)
    @cursor = string.length if match_data
    match_data
  end

  def skip_by(string)
    @cursor = string.length
  end
end