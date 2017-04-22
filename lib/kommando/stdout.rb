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
      if (match_data = matcher.match @matcher_buffer)
        matcher.call match_data
        unless matcher.class == EveryMatcher
          @matchers.delete matcher  #TODO: is this safe?
        end

        matcher.nested_matchers.each do |nested_matcher|
          if nested_matcher.class == EveryMatcher
            nested_matcher.skip_with(@matcher_buffer)
          end
          @matchers = @matchers + [nested_matcher] #TODO: is this safe?
        end
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

    string.define_singleton_method(:every) do |regexp, &block|
      m = Kommando::EveryMatcher.new regexp, block
      matchers << m
      m
    end

    string
  end

end; end