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
    @name == another.name
  end
end