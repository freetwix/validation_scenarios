require File.dirname(__FILE__) +  '/test_helper'


class Foo
  include ValidationScenarios::With
end


describe "Scenario#==" do
  
  it "should return false comparing a scenario with another by name" do
    dude = ValidationScenarios::Scenario.new(:dude)
    foo = ValidationScenarios::Scenario.new(:foo)
    
    dude.should.not == foo
  end

  it "should return true comparing a scenario with another by name" do
    dude = ValidationScenarios::Scenario.new(:dude)
    dude_too = ValidationScenarios::Scenario.new(:dude)
    
    dude.should == dude_too
  end

  it "should return false comparing a scenario with nil" do
    dude = ValidationScenarios::Scenario.new(:dude)
    
    dude.should.not == nil
  end
end


describe "Scenario#in_scenario?" do
  
  it "should return true if in scenario" do
    dude = ValidationScenarios::Scenario.new(:dude)
    
    Foo.new.with_scenario :dude do
      dude.in_scenario?.should.be true
    end    
  end

  it "should return false if not in scenario" do
    dude = ValidationScenarios::Scenario.new(:dude)
    
    Foo.new.with_scenario :foo do
      dude.in_scenario?.should.be false
    end
  end
end
