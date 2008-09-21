module ValidationScenario
  def self.included(base)
    base.__send__(:include, InstanceMethods)
  end

  module InstanceMethods
    def with_scenario(args, &block)
      Thread.current[:with_scenario] = Scenario.new(args)
      yield
      Thread.current[:with_scenario] = nil
    end
  end
  
  module ActiveRecordSupport
    def self.included(base)
      base.extend(ClassMethods)
    
      ActiveRecord::Validations.VALIDATIONS.each do |callback|
        base.class_eval <<-"end_eval"
          class << self
            def #{callback}_with_scenario(*methods, &block)
              #{callback}_without_scenario(*methods) do |record|
                unless Thread.current[:in_scenario]
                  #{callback}_without_scenario(*methods, block)
                else
                  if Thread.current[:with_scenario] == #{Thread.current[:in_scenario]}
                    true
                  else
                    block.call(record)
                  end
                end
              end
            end
            alias_method_chain #{callback}, :scenario
          end
        end_eval
      end
    end
  
    module ClassMethods
      def in_scenario(*args)
        Thread.current[:in_scenario] = Scenario.new(args)
      end
    end
  end
end
