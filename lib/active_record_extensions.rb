module ValidationScenarios
  module ActiveRecordExtensions
    def self.included(base)
      base.class_eval <<-IN_THE_EVAL
        include ValidationScenarios::With
        include InstanceMethods
      IN_THE_EVAL
    end
    
    module InstanceMethods
      def save_in_scenario(*args)
        # don't want to mess around with ar#save signature
        scenario = args.pop
        with_scenario(scenario) do
          save(args)
        end
      end

      def save_in_scenario!(scenario)
        with_scenario(scenario) do
          save!
        end
      end
    end
  end
end
