module ValidationScenarios
  class Scenario
    attr_reader :name

    def initialize(*args)
      @name = args.first.to_sym
      @options = args.last.is_a?(Hash) ? args.pop : {}
    end

    def [](key)
      @options[key]
    end

    def ==(another)
      return false if another.nil?
      @name == another.name
    end

    def in_scenario?
      self == Thread.current[:with_scenario]
    end
  end
end