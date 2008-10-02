$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
gem 'test-spec', '=0.9'
require 'test/spec'

RAILS_GEM_VERSION = ENV['RAILS_GEM_VERSION'] || '2.1.1'
gem 'rails', RAILS_GEM_VERSION

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
