require 'scenario'
require 'active_record_support'
require 'with'

ActiveRecord::Base.class_eval do
  include ValidationScenarios::ActiveRecordSupport
end

ActionController::Base.class_eval do
  include ValidationScenarios::With
end