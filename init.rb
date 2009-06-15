require 'scenario'
require 'active_record_support'
require 'active_record_extensions'
require 'with'

class ActiveRecord::Base
  include ValidationScenarios::ActiveRecordSupport
  include ValidationScenarios::ActiveRecordExtensions
end

class ActionController::Base
  include ValidationScenarios::With
end
