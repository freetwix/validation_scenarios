module ValidationScenarios
  module With
    ##
    # 
    # Declares a scenario context. All Model validations for this scenario will be activated within 
    # the block.
    #
    #   Controller:
    #     class ReviewController < ApplicationController
    #       def update
    #         with_scenario :reviewer do
    #           @event.save!
    #         end
    #       end
    # 
    # Any validates_xxx defined in the Event for the scenario :reviewer will be activated, all other
    # validations are still working. 
    #
    def with_scenario(args, &block)
      Thread.current[:with_scenario] = Scenario.new(args)
      yield
    ensure
      Thread.current[:with_scenario] = nil
    end
  end
end
