require 'scenario'
require 'active_record_support'
require 'with'

class ActiveRecord::Base
  include ValidationScenarios::ActiveRecordSupport
end

class ActionController::Base
  include ValidationScenarios::With
end
