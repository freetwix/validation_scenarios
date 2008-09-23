require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

task :default => :test

desc 'Test the validation_scenarios plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

