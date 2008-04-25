require File.dirname(__FILE__) + '/../spec_helper'

describe <%= group_plural_class %>Controller do
  describe "route generation" do

    it "should map { :controller => '<%= group_plural %>', :action => 'index' } to /<%= group_plural %>" do
      route_for(:controller => "<%= group_plural %>", :action => "index").should == "/<%= group_plural %>"
    end
    
    it "should map { :controller => '<%= group_plural %>', :action => 'new' } to /<%= group_plural %>/new" do
      route_for(:controller => "<%= group_plural %>", :action => "new").should == "/<%= group_plural %>/new"
    end
    
    it "should map { :controller => '<%= group_plural %>', :action => 'show', :id => 1 } to /<%= group_plural %>/1" do
      route_for(:controller => "<%= group_plural %>", :action => "show", :id => 1).should == "/<%= group_plural %>/1"
    end
    
    it "should map { :controller => '<%= group_plural %>', :action => 'edit', :id => 1 } to /<%= group_plural %>/1/edit" do
      route_for(:controller => "<%= group_plural %>", :action => "edit", :id => 1).should == "/<%= group_plural %>/1/edit"
    end
    
    it "should map { :controller => '<%= group_plural %>', :action => 'update', :id => 1} to /<%= group_plural %>/1" do
      route_for(:controller => "<%= group_plural %>", :action => "update", :id => 1).should == "/<%= group_plural %>/1"
    end
    
    it "should map { :controller => '<%= group_plural %>', :action => 'destroy', :id => 1} to /<%= group_plural %>/1" do
      route_for(:controller => "<%= group_plural %>", :action => "destroy", :id => 1).should == "/<%= group_plural %>/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => '<%= group_plural %>', action => 'index' } from GET /<%= group_plural %>" do
      params_from(:get, "/<%= group_plural %>").should == {:controller => "<%= group_plural %>", :action => "index"}
    end
  
    it "should generate params { :controller => '<%= group_plural %>', action => 'new' } from GET /<%= group_plural %>/new" do
      params_from(:get, "/<%= group_plural %>/new").should == {:controller => "<%= group_plural %>", :action => "new"}
    end
  
    it "should generate params { :controller => '<%= group_plural %>', action => 'create' } from POST /<%= group_plural %>" do
      params_from(:post, "/<%= group_plural %>").should == {:controller => "<%= group_plural %>", :action => "create"}
    end
  
    it "should generate params { :controller => '<%= group_plural %>', action => 'show', id => '1' } from GET /<%= group_plural %>/1" do
      params_from(:get, "/<%= group_plural %>/1").should == {:controller => "<%= group_plural %>", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => '<%= group_plural %>', action => 'edit', id => '1' } from GET /<%= group_plural %>/1/edit" do
      params_from(:get, "/<%= group_plural %>/1/edit").should == {:controller => "<%= group_plural %>", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => '<%= group_plural %>', action => 'update', id => '1' } from PUT /<%= group_plural %>/1" do
      params_from(:put, "/<%= group_plural %>/1").should == {:controller => "<%= group_plural %>", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => '<%= group_plural %>', action => 'destroy', id => '1' } from DELETE /<%= group_plural %>/1" do
      params_from(:delete, "/<%= group_plural %>/1").should == {:controller => "<%= group_plural %>", :action => "destroy", :id => "1"}
    end
  end
end
