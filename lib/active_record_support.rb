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
      #       in_scenario :reviewer do |s|
      #         s.validates_presence_of :reviewer_note
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
      def in_scenario(*args)
        yield(Proxy.new(self, ValidationScenarios::Scenario.new(*args)))
      end
    end

    ##
    # proxy for the underlying active_record object (here: event) if using validates_xxx methods in the
    # context of an #in_scenario block
    #
    class Proxy < BlankSlate #:doc:
      def initialize(model_clazz, scenario)
        @model_clazz = model_clazz
        @scenario    = scenario
      end

      def method_missing(m, *args, &block)
        __blend__(*args) if m.to_s =~ /validates_*/
        @model_clazz.__send__(m, *args, &block)
      end

      private

        ##
        # support for disable a validation for a scenario (and leave it as a validation for 
        # all other cases)
        #
        def __blend__(*args) #:doc:
          options = args.last || args.push{}
          expression = (true === options.delete(:disable_for_scenario) ? :unless : :if)
          __blend_with_expression__(expression, options)
        end

        ##
        # this relies heavy on the internals of rails, cause validation macros are stored via callbacks
        # and i did not find a better solution
        #        
        def __blend_with_expression__(expression, options) #:doc:
          if expression_option = options[expression]
            options[expression] = Proc.new { |record|
              @scenario.in_scenario? &&
                ActiveSupport::Callbacks::Callback.new(:kind, :method).__send__(:evaluate_method, expression_option, record)
            }
          else
            options[expression] = Proc.new { @scenario.in_scenario? }
          end
        end
    end
  end
end
