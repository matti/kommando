class Kommando::Matchers::Once < Kommando::Matchers::Base
  def match(string)
    string.match(@regexp)
  end
end