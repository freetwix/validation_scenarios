require File.dirname(__FILE__) +  '/test_helper'


# see db/schema.rb for 'events' attributes
class Event < ActiveRecord::Base
  attr_accessor :bar, :foo, :dude
  
  validates_presence_of :title, :unless => Proc.new { in_scenario? :disable_title }

  validates_presence_of :comment, :unless => Proc.new { in_scenarios? :disable_title, :more_disable_title }
  
  # instance based scenario validation
  validates_presence_of :short_description, :if => Proc.new { |e| e.in_scenario? :short_required }
  
  in_scenario :description_required do |me|
    me.validates_length_of :description, :in => 10..2000
  end

  in_scenario :bar_required_for_title_validation do |me|
    me.validates_length_of :title, :in => 10..2000, :if => Proc.new { |r| r.bar }
  end

  in_scenario :foo_required_for_title_validation do |me|
    me.validates_length_of :title, :in => 10..2000, :if => :foo
  end

  in_scenario :dude_required_for_title_validation do |me|
    me.validates_length_of :title, :in => 10..2000, :if => 'dude'
  end
  
  in_scenario :without_any_options do |me|
    me.validates_presence_of :description
  end
end


describe "Model with scenarios and an validation with no :if option" do  
  before do
    @valid_event = create_valid_event
    @foo = Foo.new
  end

  it "should not be valid after instantiation" do
    Event.new.should.not.be.valid
  end

  it "should be valid after instantiation with a title" do
    @valid_event.valid?
    @valid_event.should.be.valid
  end

  it "should not be valid in the scenario without description" do
    @foo.with_scenario :description_required do
      @valid_event.should.not.be.valid
    end
  end

  it "should be valid in the scenario with a description" do
    @valid_event.description = 'This is a description'

    @foo.with_scenario :description_required do
      @valid_event.should.be.valid
    end
  end

  it "should not be valid in the scenario with a description but a missing title" do
    event = Event.new(:description => 'This is a description')

    @foo.with_scenario :description_required do
      event.should.not.be.valid
    end
  end

  it "should be valid again leaving the scenario scope caused by an exception" do
    begin
      @foo.with_scenario :description_required do
        @valid_event.should.not.be.valid
        raise Exception
      end
    rescue Exception
      @valid_event.should.be.valid
    end
  end
end


describe "Model in a scenario and a validation  on description without any further options" do
  before do
    @valid_event = create_valid_event
    @foo = Foo.new
  end

  it "should not be valid if description is missing" do
    @foo.with_scenario :without_any_options do
      @valid_event.should.not.be.valid
    end
  end

  it "should be valid if description is present" do
    @valid_event.description = 'found by gzigzigzeo'
    
    @foo.with_scenario :without_any_options do
      @valid_event.should.be.valid
    end
  end
end


describe "Model with scenarios and an validation with :if option as a proc" do
  before do
    @valid_event = create_valid_event
    @foo = Foo.new
  end

  it "should be valid in the scenario if the validation should not occur" do
    @valid_event.bar = nil

    @foo.with_scenario :bar_required_for_title_validation do
      @valid_event.should.be.valid
    end
  end

  it "should not be valid in the scenario if the validation should occur" do
    @valid_event.bar = 'bar'

    @foo.with_scenario :bar_required_for_title_validation do
      @valid_event.should.not.be.valid
    end
  end
end


describe "Model with scenarios and an validation with :if option as a symbol" do
  before do
    @valid_event = create_valid_event
    @foo = Foo.new
  end

  it "should be valid in the scenario if the validation should not occur" do
    @valid_event.foo = nil

    @foo.with_scenario :foo_required_for_title_validation do
      @valid_event.should.be.valid
    end
  end

  it "should not be valid in the scenario if the validation should occur" do
    @valid_event.foo = 'foo'

    @foo.with_scenario :foo_required_for_title_validation do
      @valid_event.should.not.be.valid
    end
  end
end


describe "Model with scenarios and an validation with :if option as a string" do
  before do
    @valid_event = create_valid_event
    @foo = Foo.new
  end

  it "should be valid in the scenario if the validation should not occur" do
    @valid_event.dude = nil

    @foo.with_scenario :dude_required_for_title_validation do
      @valid_event.should.be.valid
    end
  end

  it "should not be valid in the scenario if the validation should occur" do
    @valid_event.dude = 'dude'

    @foo.with_scenario :dude_required_for_title_validation do
      @valid_event.should.not.be.valid
    end
  end
end


describe "Model with scenarios and an validation skipping in a scenario" do
  before do
    @event = Event.new()
    @foo = Foo.new
  end

  it "should not be valid outside the scenario without title" do
    @event.should.not.be.valid
  end  

  it "should be valid in the scenario without title" do
    @foo.with_scenario :disable_title do
      @event.should.be.valid
    end
  end
end


describe "Model with scenarios and an validation skipping in some scenarios" do
  before do
    @event = Event.new()
    @foo = Foo.new
  end

  it "should not be valid outside the scenario without title" do
    @event.should.not.be.valid
  end  

  it "should be valid in one scenario without title and comment" do
    @foo.with_scenario :disable_title do
      @event.should.be.valid
    end
  end

  it "should be valid in another scenario without comment but title" do
    @event.title = 'dude'
    @foo.with_scenario :more_disable_title do
      @event.should.be.valid
    end
  end
end


describe "Model with instance-based scenario validation" do
  before do
    @event = create_valid_event
    @foo = Foo.new
  end
  
  it "should not be valid without 'short_description' in scenario :short_required" do
    @foo.with_scenario :short_required do
      @event.should.not.be.valid
    end
  end

  it "should be valid without 'short_description' in scenario :short_required" do
    @event.short_description = 'dude'
    
    @foo.with_scenario :short_required do
      @event.should.be.valid
    end
  end
end
