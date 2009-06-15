$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
gem 'test-spec', '=0.9'
require 'test/spec'

RAILS_EDGE_PATH = File.join(File.dirname(__FILE__), 'vendor/rails')
if File.exist?(RAILS_EDGE_PATH)
  RAILS_GEM_VERSION = 'edge'
  Dir[File.join(RAILS_EDGE_PATH, '**','lib')].each do |libdir|
    $LOAD_PATH.unshift libdir
  end  
else
  RAILS_GEM_VERSION = ENV['RAILS_GEM_VERSION'] || '2.3.2'
  gem 'rails', RAILS_GEM_VERSION  
end

require 'action_controller'
require 'active_record'
require 'active_support'
require 'action_pack/version'
require 'active_record/version'
require 'active_support/version'

puts <<-OLLA

testing for rails-#{RAILS_GEM_VERSION}: 
  - [action_pack-#{ActionPack::VERSION::STRING}] action_controller
  - active_record-#{ActiveRecord::VERSION::STRING}
  - active_support-#{ActiveSupport::VERSION::STRING}
  
OLLA

RAILS_ROOT = File.dirname(__FILE__)
config = YAML::load(IO.read(File.dirname(__FILE__) + '/config/database.yml'))
ActiveRecord::Base.logger = Logger.new('/dev/null')
ActiveRecord::Base.establish_connection(config['test'])

ActiveRecord::Schema.verbose = false
require File.dirname(__FILE__) + "/db/schema.rb"

require "#{File.dirname(__FILE__)}/../init"


# helper methods and classes
def create_valid_event
  Event.new(:title => 'title', :comment => 'dude')  
end

class Foo
  include ValidationScenarios::With
end
