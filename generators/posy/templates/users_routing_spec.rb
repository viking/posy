require File.dirname(__FILE__) + '/../spec_helper'

describe <%= user_plural_class %>Controller do

  describe "route generation" do

    it "should map { :controller => '<%= user_plural %>', :action => 'index' } to /<%= user_plural %>" do
      route_for(:controller => "<%= user_plural %>", :action => "index").should == "/<%= user_plural %>"
    end
    
    it "should map { :controller => '<%= user_plural %>', :action => 'new' } to /<%= user_plural %>/new" do
      route_for(:controller => "<%= user_plural %>", :action => "new").should == "/<%= user_plural %>/new"
    end
    
    it "should map { :controller => '<%= user_plural %>', :action => 'show', :id => 1 } to /<%= user_plural %>/1" do
      route_for(:controller => "<%= user_plural %>", :action => "show", :id => 1).should == "/<%= user_plural %>/1"
    end
    
    it "should map { :controller => '<%= user_plural %>', :action => 'edit', :id => 1 } to /<%= user_plural %>/1/edit" do
      route_for(:controller => "<%= user_plural %>", :action => "edit", :id => 1).should == "/<%= user_plural %>/1/edit"
    end
    
    it "should map { :controller => '<%= user_plural %>', :action => 'update', :id => 1} to /<%= user_plural %>/1" do
      route_for(:controller => "<%= user_plural %>", :action => "update", :id => 1).should == "/<%= user_plural %>/1"
    end
    
    it "should map { :controller => '<%= user_plural %>', :action => 'destroy', :id => 1} to /<%= user_plural %>/1" do
      route_for(:controller => "<%= user_plural %>", :action => "destroy", :id => 1).should == "/<%= user_plural %>/1"
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => '<%= user_plural %>', action => 'index' } from GET /<%= user_plural %>" do
      params_from(:get, "/<%= user_plural %>").should == {:controller => "<%= user_plural %>", :action => "index"}
    end
  
    it "should generate params { :controller => '<%= user_plural %>', action => 'new' } from GET /<%= user_plural %>/new" do
      params_from(:get, "/<%= user_plural %>/new").should == {:controller => "<%= user_plural %>", :action => "new"}
    end
  
    it "should generate params { :controller => '<%= user_plural %>', action => 'create' } from POST /<%= user_plural %>" do
      params_from(:post, "/<%= user_plural %>").should == {:controller => "<%= user_plural %>", :action => "create"}
    end
  
    it "should generate params { :controller => '<%= user_plural %>', action => 'show', id => '1' } from GET /<%= user_plural %>/1" do
      params_from(:get, "/<%= user_plural %>/1").should == {:controller => "<%= user_plural %>", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => '<%= user_plural %>', action => 'edit', id => '1' } from GET /<%= user_plural %>/1/edit" do
      params_from(:get, "/<%= user_plural %>/1/edit").should == {:controller => "<%= user_plural %>", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => '<%= user_plural %>', action => 'update', id => '1' } from PUT /<%= user_plural %>/1" do
      params_from(:put, "/<%= user_plural %>/1").should == {:controller => "<%= user_plural %>", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => '<%= user_plural %>', action => 'destroy', id => '1' } from DELETE /<%= user_plural %>/1" do
      params_from(:delete, "/<%= user_plural %>/1").should == {:controller => "<%= user_plural %>", :action => "destroy", :id => "1"}
    end
  end
end
