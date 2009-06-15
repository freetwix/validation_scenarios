module ValidationScenarios
  module ActiveRecordSupport
    def self.included(base)
      base.class_eval <<-IN_THE_EVAL
        extend ClassMethods
        extend Methods
        include Methods
      IN_THE_EVAL
    end
    
    module ClassMethods
      ##
      # Use around any validates_xxx
      # 
      def in_scenario(name, &blk)
        yield(ValidatesBlenderProxy.new(self, name))
      end
    end
    
    module Methods
      ##
      # Use on any instance for scenario-based execution.
      #
      # Use in validates_xxx options (:unless, :if) Procs for validation with a scenario
      #
      def in_scenario?(name)
        Scenario.new(name).in_scenario?
      end

      ##
      # Use on any instance for scenarios-based execution.
      #
      # Use in validates_xxx options (:unless, :if) Procs for validation with scenarios (evaluates if 
      # any matches)
      #
      def in_scenarios?(*names)
        names.any? { |name| in_scenario?(name) } 
      end
    end
  end
  
  
  # proxy for the underlying active_record object (here: event) if using validates_xxx methods in the
  # context of an #in_scenario block
  class ValidatesBlenderProxy < BlankSlate #:nodoc:

    def initialize(model_clazz, scenario_name)
      @model_clazz = model_clazz
      @scenario    = ValidationScenarios::Scenario.new(scenario_name)
    end

    def method_missing(m, *args, &block)
      args = __blend__(*args) if m.to_s =~ /validates_*/
      @model_clazz.__send__(m, *args, &block)
    end

    private

      # this relies heavy on the internals of rails, cause validation macros are stored via callbacks
      # and i did not want to duplicate logic
      def __blend__(*args) #:nodoc:
        options = args.last
        options = args.push({}).last unless options.is_a?(::Hash)
        
        if original_if_option = options[:if]
          options[:if] = Proc.new { |record|
            @scenario.in_scenario? &&
              # :kind and :method fakes to initialize properly
              ActiveSupport::Callbacks::Callback.new(:kind, :method).
                  __send__(:evaluate_method, original_if_option, record)
          }
        else
          options[:if] = Proc.new { @scenario.in_scenario? }
        end
        args
      end
  end
end
