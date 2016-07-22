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

    if @fired.include? event_name_as_sym
      debug "cb firing as #{event_name_as_sym} already fired."
      block.call
      debug "cb fired as #{event_name_as_sym} already fired."
    else
      debug "cb for #{event_name_as_sym} registered, not fired."
    end
  end

  def fire(event_name)
    event_name_as_sym = event_name.to_sym
    validate_event_name(event_name_as_sym)

    @fired << event_name_as_sym
    debug "set #{event_name_as_sym} as fired"

    if blocks = @whens[event_name]
      debug "firing cbs for #{event_name_as_sym}"
      blocks.each do |block|
        debug "firing cb for #{event_name_as_sym}"
        block.call
        debug "fired cb for #{event_name_as_sym}"
      end
    else
      debug "no cbs for #{event_name_as_sym}"
    end
  end

  private
  def validate_event_name(event_name_as_sym)
    raise Kommando::Error, "When '#{event_name_as_sym}' is not known." unless VALID_EVENTS.include? event_name_as_sym
  end

  def debug(msg)
    return unless ENV["DEBUG"]
    print "W#{msg}"
  end
end
