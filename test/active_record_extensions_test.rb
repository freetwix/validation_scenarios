require File.dirname(__FILE__) +  '/test_helper'


class Jet < ActiveRecord::Base
  include ValidationScenarios::ActiveRecordExtensions
  
  validates_presence_of :pilotes, :if => Proc.new { |jet| jet.in_scenario? :landing }
end


describe "Model#save_in_scenario" do
  it "should be saveable if valid" do
    Jet.new.save_in_scenario(:valid).should.be true
  end
  
  it "should not be saveable if invalid" do
    Jet.new.save_in_scenario(:landing).should.be false
  end

  it "should be saveable with pilotes" do
    Jet.new(:pilotes => 2).save_in_scenario(:landing).should.be true
  end
end


describe "Model#save_in_scenario!" do
  it "should not raise and save if valid" do
    Jet.new.save_in_scenario!(:valid).should.be true
  end
  
  it "should raise and not save if invalid" do
    Proc.new { Jet.new.save_in_scenario!(:landing) }.should.raise(ActiveRecord::RecordInvalid)
  end

  it "should not raise and save if pilotes on board" do
    Jet.new(:pilotes => 2).save_in_scenario!(:landing).should.be true
  end
end


describe "Model#save_in_scenario with excessively scenario usage" do
  it "should be the last scenario be with u, failing" do
    Foo.new.with_scenario(:landing) do
      Jet.new.save_in_scenario(:valid).should.be true
    end
  end

  it "should be the last scenario with u, success" do
    Foo.new.with_scenario(:valid) do
      Jet.new.save_in_scenario(:landing).should.be false
    end
  end
end
