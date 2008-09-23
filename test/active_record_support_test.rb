require File.dirname(__FILE__) +  '/test_helper'

class Event < ActiveRecord::Base
  attr_accessor :bar, :foo, :dude

  validates_presence_of :title

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
end

class Foo
  include ValidationScenarios::With
end


describe "Model with ValidationScenario::ActiveRecordSupport, no :if option" do
  before do
    @valid_event = Event.new(:title => 'title')
    @foo = Foo.new
  end

  it "should not be valid after instantiation" do
    Event.new.should.not.be.valid
  end

  it "should be valid after instantiation with a title" do
    @valid_event.should.be.valid
  end

  it "should not be valid in scenario :description_required" do
    @foo.with_scenario :description_required do
      @valid_event.should.not.be.valid
    end
  end

  it "should not be valid in scenario :description_required" do
    @foo.with_scenario :description_required do
      @valid_event.should.not.be.valid
    end
  end

  it "should be valid in scenario :description_required with a description set" do
    @valid_event.description = 'This is a description'

    @foo.with_scenario :description_required do
      @valid_event.should.be.valid
    end
  end

  it "should not be valid in scenario :description_required with a description set but a mising title" do
    event = Event.new(:description => 'This is a description')

    @foo.with_scenario :description_required do
      event.should.not.be.valid
    end
  end

  it "should be valid again leaving the scenario scope" do
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


describe "Model with ValidationScenario::ActiveRecordSupport and :if option as a proc" do
  before do
    @valid_event = Event.new(:title => 'title')
    @foo = Foo.new
  end

  it "should be valid in scenario :bar_required_for_title_validation if bar not given" do
    @valid_event.bar = nil

    @foo.with_scenario :bar_required_for_title_validation do
      @valid_event.should.be.valid
    end
  end

  it "should not be valid in scenario :bar_required_for_title_validation if bar given" do
    @valid_event.bar = 'bar'

    @foo.with_scenario :bar_required_for_title_validation do
      @valid_event.should.not.be.valid
    end
  end
end


describe "Model with ValidationScenario::ActiveRecordSupport and :if option as a symbol" do
  before do
    @valid_event = Event.new(:title => 'title')
    @foo = Foo.new
  end

  it "should be valid in scenario :foo_required_for_title_validation if foo not given" do
    @valid_event.foo = nil

    @foo.with_scenario :foo_required_for_title_validation do
      @valid_event.should.be.valid
    end
  end

  it "should not be valid in scenario :foo_required_for_title_validation if foo given" do
    @valid_event.foo = 'foo'

    @foo.with_scenario :foo_required_for_title_validation do
      @valid_event.should.not.be.valid
    end
  end
end

describe "Model with ValidationScenario::ActiveRecordSupport and :if option as a string" do
  before do
    @valid_event = Event.new(:title => 'title')
    @foo = Foo.new
  end

  it "should be valid in scenario :dude_required_for_title_validation if dude not given" do
    @valid_event.dude = nil

    @foo.with_scenario :dude_required_for_title_validation do
      @valid_event.should.be.valid
    end
  end

  it "should not be valid in scenario :dude_required_for_title_validation if dude given" do
    @valid_event.dude = 'dude'

    @foo.with_scenario :dude_required_for_title_validation do
      @valid_event.should.not.be.valid
    end
  end
end

