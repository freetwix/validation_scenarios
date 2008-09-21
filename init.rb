require 'validation_scenario'
require 'scenario'

ActiveRecord::Base.class_eval do
  include ValidationScenario::ActiveRecordSupport
end

ActionController::Base.class_eval do
  include ValidationScenario
end