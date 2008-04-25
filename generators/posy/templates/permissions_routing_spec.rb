require File.dirname(__FILE__) + '/../spec_helper'

describe <%= permission_plural_class %>Controller do

  describe "route generation" do

    it "should map { :controller => '<%= permission_plural %>', :action => 'index' } to /<%= permission_plural %>" do
      route_for(:controller => "<%= permission_plural %>", :action => "index").should == "/<%= permission_plural %>"
    end
    
    it "should map { :controller => '<%= permission_plural %>', :action => 'new' } to /<%= permission_plural %>/new" do
      route_for(:controller => "<%= permission_plural %>", :action => "new").should == "/<%= permission_plural %>/new"
    end
    
    it "should map { :controller => '<%= permission_plural %>', :action => 'show', :id => 1 } to /<%= permission_plural %>/1" do
      route_for(:controller => "<%= permission_plural %>", :action => "show", :id => 1).should == "/<%= permission_plural %>/1"
    end
    
    it "should map { :controller => '<%= permission_plural %>', :action => 'edit', :id => 1 } to /<%= permission_plural %>/1/edit" do
      route_for(:controller => "<%= permission_plural %>", :action => "edit", :id => 1).should == "/<%= permission_plural %>/1/edit"
    end
    
    it "should map { :controller => '<%= permission_plural %>', :action => 'update', :id => 1} to /<%= permission_plural %>/1" do
      route_for(:controller => "<%= permission_plural %>", :action => "update", :id => 1).should == "/<%= permission_plural %>/1"
    end
    
    it "should map { :controller => '<%= permission_plural %>', :action => 'destroy', :id => 1} to /<%= permission_plural %>/1" do
      route_for(:controller => "<%= permission_plural %>", :action => "destroy", :id => 1).should == "/<%= permission_plural %>/1"
    end
    
    describe "for <%= group_plural %>" do
      it "should map { :controller => '<%= permission_plural %>', :action => 'index', :<%= group_singular %>_id => 1 } to /<%= group_plural %>/1/<%= permission_plural %>" do
        route_for(:controller => "<%= permission_plural %>", :action => "index", :<%= group_singular %>_id => 1).should == "/<%= group_plural %>/1/<%= permission_plural %>"
      end
      
      it "should map { :controller => '<%= permission_plural %>', :action => 'new', :<%= group_singular %>_id => 1 } to /<%= group_plural %>/1/<%= permission_plural %>/new" do
        route_for(:controller => "<%= permission_plural %>", :action => "new", :<%= group_singular %>_id => 1).should == "/<%= group_plural %>/1/<%= permission_plural %>/new"
      end
      
      it "should map { :controller => '<%= permission_plural %>', :action => 'show', :id => 1, :<%= group_singular %>_id => 1 } to /<%= group_plural %>/1/<%= permission_plural %>/1" do
        route_for(:controller => "<%= permission_plural %>", :action => "show", :id => 1, :<%= group_singular %>_id => 1).should == "/<%= group_plural %>/1/<%= permission_plural %>/1"
      end
      
      it "should map { :controller => '<%= permission_plural %>', :action => 'destroy', :id => 1, :<%= group_singular %>_id => 1 } to /<%= group_plural %>/1/<%= permission_plural %>/1" do
        route_for(:controller => "<%= permission_plural %>", :action => "destroy", :id => 1, :<%= group_singular %>_id => 1).should == "/<%= group_plural %>/1/<%= permission_plural %>/1"
      end
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => '<%= permission_plural %>', action => 'index' } from GET /<%= permission_plural %>" do
      params_from(:get, "/<%= permission_plural %>").should == {:controller => "<%= permission_plural %>", :action => "index"}
    end
  
    it "should generate params { :controller => '<%= permission_plural %>', action => 'new' } from GET /<%= permission_plural %>/new" do
      params_from(:get, "/<%= permission_plural %>/new").should == {:controller => "<%= permission_plural %>", :action => "new"}
    end
  
    it "should generate params { :controller => '<%= permission_plural %>', action => 'create' } from POST /<%= permission_plural %>" do
      params_from(:post, "/<%= permission_plural %>").should == {:controller => "<%= permission_plural %>", :action => "create"}
    end
  
    it "should generate params { :controller => '<%= permission_plural %>', action => 'show', id => '1' } from GET /<%= permission_plural %>/1" do
      params_from(:get, "/<%= permission_plural %>/1").should == {:controller => "<%= permission_plural %>", :action => "show", :id => "1"}
    end
  
    it "should generate params { :controller => '<%= permission_plural %>', action => 'edit', id => '1' } from GET /<%= permission_plural %>/1/edit" do
      params_from(:get, "/<%= permission_plural %>/1/edit").should == {:controller => "<%= permission_plural %>", :action => "edit", :id => "1"}
    end
  
    it "should generate params { :controller => '<%= permission_plural %>', action => 'update', id => '1' } from PUT /<%= permission_plural %>/1" do
      params_from(:put, "/<%= permission_plural %>/1").should == {:controller => "<%= permission_plural %>", :action => "update", :id => "1"}
    end
  
    it "should generate params { :controller => '<%= permission_plural %>', action => 'destroy', id => '1' } from DELETE /<%= permission_plural %>/1" do
      params_from(:delete, "/<%= permission_plural %>/1").should == {:controller => "<%= permission_plural %>", :action => "destroy", :id => "1"}
    end

    describe "for <%= group_plural %>" do
      it "should generate params { :controller => '<%= permission_plural %>', action => 'index', :<%= group_singular %>_id => 1 } from GET /<%= group_plural %>/1/<%= permission_plural %>" do
        params_from(:get, "/<%= group_plural %>/1/<%= permission_plural %>").should == {:controller => "<%= permission_plural %>", :action => "index", :<%= group_singular %>_id => "1"}
      end
    
      it "should generate params { :controller => '<%= permission_plural %>', action => 'new', :<%= group_singular %>_id => 1 } from GET /<%= group_plural %>/1/<%= permission_plural %>/new" do
        params_from(:get, "/<%= group_plural %>/1/<%= permission_plural %>/new").should == {:controller => "<%= permission_plural %>", :action => "new", :<%= group_singular %>_id => "1"}
      end
    
      it "should generate params { :controller => '<%= permission_plural %>', action => 'create', :<%= group_singular %>_id => 1 } from POST /<%= group_plural %>/1/<%= permission_plural %>" do
        params_from(:post, "/<%= group_plural %>/1/<%= permission_plural %>").should == {:controller => "<%= permission_plural %>", :action => "create", :<%= group_singular %>_id => "1"}
      end
    
      it "should generate params { :controller => '<%= permission_plural %>', action => 'show', id => '1', :<%= group_singular %>_id => 1 } from GET /<%= group_plural %>/1/<%= permission_plural %>/1" do
        params_from(:get, "/<%= group_plural %>/1/<%= permission_plural %>/1").should == {:controller => "<%= permission_plural %>", :action => "show", :id => "1", :<%= group_singular %>_id => "1"}
      end
    
      it "should generate params { :controller => '<%= permission_plural %>', action => 'edit', id => '1', :<%= group_singular %>_id => 1 } from GET /<%= group_plural %>/1/<%= permission_plural %>/1/edit" do
        params_from(:get, "/<%= group_plural %>/1/<%= permission_plural %>/1/edit").should == {:controller => "<%= permission_plural %>", :action => "edit", :id => "1", :<%= group_singular %>_id => "1"}
      end
    
      it "should generate params { :controller => '<%= permission_plural %>', action => 'update', id => '1', :<%= group_singular %>_id => 1 } from PUT /<%= group_plural %>/1/<%= permission_plural %>/1" do
        params_from(:put, "/<%= group_plural %>/1/<%= permission_plural %>/1").should == {:controller => "<%= permission_plural %>", :action => "update", :id => "1", :<%= group_singular %>_id => "1"}
      end
    
      it "should generate params { :controller => '<%= permission_plural %>', action => 'destroy', id => '1', :<%= group_singular %>_id => 1 } from DELETE /<%= group_plural %>/1/<%= permission_plural %>/1" do
        params_from(:delete, "/<%= group_plural %>/1/<%= permission_plural %>/1").should == {:controller => "<%= permission_plural %>", :action => "destroy", :id => "1", :<%= group_singular %>_id => "1"}
      end
    end
  end
end
