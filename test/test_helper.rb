$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
gem 'test-spec', '=0.9'
require 'test/spec'

require 'action_controller'
require 'active_record'
require 'active_support'

RAILS_ROOT = File.dirname(__FILE__)
config = YAML::load(IO.read(File.dirname(__FILE__) + '/config/database.yml'))
ActiveRecord::Base.logger = Logger.new('/dev/null')
ActiveRecord::Base.establish_connection(config['test'])

ActiveRecord::Schema.verbose = false
require File.dirname(__FILE__) + "/db/schema.rb"

require "#{File.dirname(__FILE__)}/../init"
