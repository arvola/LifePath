# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

module Rapid

    # An object to bind events with
    class Event
        def initialize
            @listeners = {}
        end

        # Adds an event to the object that blocks
        # can register to.
        # Could just use method_missing to catch events, but that costs
        # performance. In addition, needing to define them first makes
        # the code more explicit and clearer.
        def _add_event symbol
            # It already exists, let's just return
            return self if self.class.method_defined?(symbol)

            debuglog "Creating event " + symbol.to_s
            # If the event method is given a block, it's added as a listener.
            # If no block is given, it fires the event instead.
            # The event firing can be given any number of arguments that will
            # then be expanded to the event call.
            eventer = lambda do |*p, &block|
                if (defined?(block) && !block.nil?)
                    debuglog "Subscribing to event " + symbol.to_s
                    @listeners[symbol] = [] unless (defined?(@listeners[symbol]) && @listeners[symbol] != nil)
                    @listeners[symbol].push(block)
                else
                    debuglog "Firing event " + symbol.to_s
                    if defined?(@listeners[symbol]) && @listeners[symbol] != nil
                        @listeners[symbol].each { |block| block.call(symbol.id2name, *p) }
                    else
                        debuglog "No listeners for event " + symbol.to_s
                    end
                end
            end

            self.class.send(:define_method, symbol, &eventer)
            self
        end

        alias :<< :_add_event

        # Removes all bindings from a specific event
        def _unbind symbol
            @listeners[symbol] = []
        end

        alias :- :_unbind

        # Explicit method for firing an event
        def _fire symbol
            if defined? @listeners[symbol]
                @listeners[symbol].each { |&block| block.call symbol.id2name }
            end
        end

        def method_missing(symbol, *args, &block)
            warnlog 'Tried to subscribe to or fire a non-existent event: ' + symbol.to_s
        end
    end
end