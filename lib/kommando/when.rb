class Kommando::When
  def initialize
    @whens = {}
  end

  def register(event_name, block)
    @whens[event_name.to_sym] = if @whens[event_name.to_sym]
      @whens[event_name.to_sym] << block
    else
      [block]
    end
  end

  def fire(event_name)
    return unless blocks = @whens[event_name]

    blocks.each do |block|
      block.call
    end
  end
end
