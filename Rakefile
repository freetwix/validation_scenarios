require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

task :default => :test

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
Rake::Task['test'].comment = <<-DESC
Test the validation_scenarios plugin

Use '> RAILS_GEM_VERSION=2.1 rake test' to test for a special version of rails 
(You first need to install it as a gem) or
link a rails git repo to 'test/vendor/rails' to fire the tests against edge
rails.

DESC