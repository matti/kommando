class Kommando::When
  VALID_EVENTS = :start, :retry, :timeout, :error, :exit

  def initialize
    @whens = {}
    @fired = []
  end

  def register(event_name, block)
    event_name_as_sym = event_name.to_sym
    validate_event_name(event_name_as_sym)

    @whens[event_name_as_sym] = if @whens[event_name_as_sym]
      @whens[event_name_as_sym] << block
    else
      [block]
    end

    block.call if @fired.include? event_name_as_sym
  end

  def fire(event_name)
    event_name_as_sym = event_name.to_sym
    validate_event_name(event_name_as_sym)

    @fired << event_name_as_sym
    return unless blocks = @whens[event_name]

    blocks.each do |block|
      block.call
    end
  end

  private
  def validate_event_name(event_name_as_sym)
    raise Kommando::Error, "When '#{event_name_as_sym}' is not known." unless VALID_EVENTS.include? event_name_as_sym
  end
end
