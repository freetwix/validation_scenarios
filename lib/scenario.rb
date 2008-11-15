module ValidationScenarios
  class Scenario
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def ==(scenario)
      @name == scenario.name rescue false
    end

    def in_scenario?
      self == Thread.current[:validation_scenarios_with_scenario]
    end
  end
end