class ReviewController < ApplicationController

  def update
    @event.description = params[:event][:description]
    
    with_scenario :review do
      @event.save!
    end
  end
end