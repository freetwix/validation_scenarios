module ValidationScenarios
  module ActiveRecordSupport
    def self.included(base)
      base.extend(ClassMethods)
    end
    module ClassMethods
      ##
      # Define validates_xxx methods on a Model for scenarios. The validation will only occur, if the
      # Model is used in a scenario:
      #
      #   Model:
      #     class Event < ActiveRecord::Base
      #       validates_presence_of :title
      #
      #       in_scenario :reviewer do |me|
      #         me.validates_presence_of :reviewer_note
      #       end
      #
      #   Controller:
      #     class ReviewController < ApplicationController
      #       def create
      #         @event = Event.new(params[:event])
      #         @event.save!
      #       end
      #
      #       def update
      #         with_scenario :reviewer do
      #           @event.save!
      #         end
      #       end
      #
      # The :symbol given to #in_scenario is the identifier for the scenario, which is then activated
      # via the #with_scenario block.
      #
      # If you want to exclude a default validation within a scenario, you may do so with the following
      # code:
      #
      #   Model:
      #     class Event < ActiveRecord::Base
      #       validates_uniqueness_of :title, :unless => Proc.new { in_scenario? :bulk_insert }
      #
      #       validates_presence_of :description, :unless => Proc.new { in_scenarios? :bulk_insert, :reviewer }
      #
      #       in_scenario :reviewer do |me|
      #         me.validates_presence_of :reviewer_note
      #       end
      #
      # You may have noticed the #in_scenarios? method, which can be used for multiple assignments of
      # scenarios.
      # 
      def in_scenario(name, &blk)
        yield(ValidatesBlenderProxy.new(self, name))
      end
    
      ##
      # Use in validates_xxx :unless option Procs to disable a default validation in a certain scenario
      #
      def in_scenario?(name)
        Scenario.new(name).in_scenario?
      end

      ##
      # Use in validates_xxx :unless option Procs to disable a default validation for some scenarios
      #
      def in_scenarios?(*names)
        names.find { |name| in_scenario?(name) } 
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
