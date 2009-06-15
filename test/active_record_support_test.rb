require File.dirname(__FILE__) +  '/test_helper'


describe "Model#in_scenario?" do
  before do
    @event = Event.new
  end
  
  it "should be a valid instance method" do
    @event.should.respond_to :in_scenario?
  end

  it "should behave like the Model.in_scenario? method" do
    Foo.new.with_scenario(:foo) do
      @event.in_scenario?(:foo).should.be true
      @event.in_scenario?(:bar).should.be false
    end
  end
end

describe "Model#in_scenarios?" do
  before do
    @event = Event.new
  end
  
  it "should be a valid instance method" do
    @event.should.respond_to :in_scenarios?
  end

  it "should behave like the Model.in_scenarios? method" do
    Foo.new.with_scenario(:foo) do
      @event.in_scenarios?(:foo).should.be true
      @event.in_scenarios?(:bar, :foobar).should.be false
    end
  end
end
