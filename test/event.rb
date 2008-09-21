class Events < ActiveRecord::Base
  validates_presence_of :title
  
  in_scenario :review do
    validates_length_of :description, :in => 10..2000
  end
end