require File.dirname(__FILE__) + '/../spec_helper'

describe <%= membership_plural_class %>Controller do

  describe "route generation" do

    it "should map { :controller => '<%= membership_plural %>', :action => 'index' } to /<%= membership_plural %>" do
      route_for(:controller => "<%= membership_plural %>", :action => "index").should == "/<%= membership_plural %>"
    end

    it "should map { :controller => '<%= membership_plural %>', :action => 'new' } to /<%= membership_plural %>/new" do
      route_for(:controller => "<%= membership_plural %>", :action => "new").should == "/<%= membership_plural %>/new"
    end

    it "should map { :controller => '<%= membership_plural %>', :action => 'show', :id => 1 } to /<%= membership_plural %>/1" do
      route_for(:controller => "<%= membership_plural %>", :action => "show", :id => 1).should == "/<%= membership_plural %>/1"
    end

    it "should map { :controller => '<%= membership_plural %>', :action => 'destroy', :id => 1} to /<%= membership_plural %>/1" do
      route_for(:controller => "<%= membership_plural %>", :action => "destroy", :id => 1).should == "/<%= membership_plural %>/1"
    end

    describe "for <%= group_plural %>" do
      it "should map { :controller => '<%= membership_plural %>', :action => 'index', :<%= group_singular %>_id => 1 } to /<%= group_plural %>/1/<%= membership_plural %>" do
        route_for(:controller => "<%= membership_plural %>", :action => "index", :<%= group_singular %>_id => 1).should == "/<%= group_plural %>/1/<%= membership_plural %>"
      end

      it "should map { :controller => '<%= membership_plural %>', :action => 'new', :<%= group_singular %>_id => 1 } to /<%= group_plural %>/1/<%= membership_plural %>/new" do
        route_for(:controller => "<%= membership_plural %>", :action => "new", :<%= group_singular %>_id => 1).should == "/<%= group_plural %>/1/<%= membership_plural %>/new"
      end

      it "should map { :controller => '<%= membership_plural %>', :action => 'show', :id => 1, :<%= group_singular %>_id => 1 } to /<%= group_plural %>/1/<%= membership_plural %>/1" do
        route_for(:controller => "<%= membership_plural %>", :action => "show", :id => 1, :<%= group_singular %>_id => 1).should == "/<%= group_plural %>/1/<%= membership_plural %>/1"
      end

      it "should map { :controller => '<%= membership_plural %>', :action => 'destroy', :id => 1, :<%= group_singular %>_id => 1 } to /<%= group_plural %>/1/<%= membership_plural %>/1" do
        route_for(:controller => "<%= membership_plural %>", :action => "destroy", :id => 1, :<%= group_singular %>_id => 1).should == "/<%= group_plural %>/1/<%= membership_plural %>/1"
      end
    end

    describe "for <%= user_plural %>" do
      it "should map { :controller => '<%= membership_plural %>', :action => 'index', :<%= user_singular %>_id => 1 } to /<%= user_plural %>/1/<%= membership_plural %>" do
        route_for(:controller => "<%= membership_plural %>", :action => "index", :<%= user_singular %>_id => 1).should == "/<%= user_plural %>/1/<%= membership_plural %>"
      end

      it "should map { :controller => '<%= membership_plural %>', :action => 'new', :<%= user_singular %>_id => 1 } to /<%= user_plural %>/1/<%= membership_plural %>/new" do
        route_for(:controller => "<%= membership_plural %>", :action => "new", :<%= user_singular %>_id => 1).should == "/<%= user_plural %>/1/<%= membership_plural %>/new"
      end

      it "should map { :controller => '<%= membership_plural %>', :action => 'show', :id => 1, :<%= user_singular %>_id => 1 } to /<%= user_plural %>/1/<%= membership_plural %>/1" do
        route_for(:controller => "<%= membership_plural %>", :action => "show", :id => 1, :<%= user_singular %>_id => 1).should == "/<%= user_plural %>/1/<%= membership_plural %>/1"
      end

      it "should map { :controller => '<%= membership_plural %>', :action => 'destroy', :id => 1, :<%= user_singular %>_id => 1 } to /<%= user_plural %>/1/<%= membership_plural %>/1" do
        route_for(:controller => "<%= membership_plural %>", :action => "destroy", :id => 1, :<%= user_singular %>_id => 1).should == "/<%= user_plural %>/1/<%= membership_plural %>/1"
      end
    end
  end

  describe "route recognition" do

    it "should generate params { :controller => '<%= membership_plural %>', action => 'index' } from GET /<%= membership_plural %>" do
      params_from(:get, "/<%= membership_plural %>").should == {:controller => "<%= membership_plural %>", :action => "index"}
    end

    it "should generate params { :controller => '<%= membership_plural %>', action => 'new' } from GET /<%= membership_plural %>/new" do
      params_from(:get, "/<%= membership_plural %>/new").should == {:controller => "<%= membership_plural %>", :action => "new"}
    end

    it "should generate params { :controller => '<%= membership_plural %>', action => 'create' } from POST /<%= membership_plural %>" do
      params_from(:post, "/<%= membership_plural %>").should == {:controller => "<%= membership_plural %>", :action => "create"}
    end

    it "should generate params { :controller => '<%= membership_plural %>', action => 'show', id => '1' } from GET /<%= membership_plural %>/1" do
      params_from(:get, "/<%= membership_plural %>/1").should == {:controller => "<%= membership_plural %>", :action => "show", :id => "1"}
    end

    it "should generate params { :controller => '<%= membership_plural %>', action => 'edit', id => '1' } from GET /<%= membership_plural %>/1/edit" do
      params_from(:get, "/<%= membership_plural %>/1/edit").should == {:controller => "<%= membership_plural %>", :action => "edit", :id => "1"}
    end

    it "should generate params { :controller => '<%= membership_plural %>', action => 'update', id => '1' } from PUT /<%= membership_plural %>/1" do
      params_from(:put, "/<%= membership_plural %>/1").should == {:controller => "<%= membership_plural %>", :action => "update", :id => "1"}
    end

    it "should generate params { :controller => '<%= membership_plural %>', action => 'destroy', id => '1' } from DELETE /<%= membership_plural %>/1" do
      params_from(:delete, "/<%= membership_plural %>/1").should == {:controller => "<%= membership_plural %>", :action => "destroy", :id => "1"}
    end

    describe "for <%= group_plural %>" do
      it "should generate params { :controller => '<%= membership_plural %>', action => 'index', :<%= group_singular %>_id => 1 } from GET /<%= group_plural %>/1/<%= membership_plural %>" do
        params_from(:get, "/<%= group_plural %>/1/<%= membership_plural %>").should == {:controller => "<%= membership_plural %>", :action => "index", :<%= group_singular %>_id => "1"}
      end

      it "should generate params { :controller => '<%= membership_plural %>', action => 'new', :<%= group_singular %>_id => 1 } from GET /<%= group_plural %>/1/<%= membership_plural %>/new" do
        params_from(:get, "/<%= group_plural %>/1/<%= membership_plural %>/new").should == {:controller => "<%= membership_plural %>", :action => "new", :<%= group_singular %>_id => "1"}
      end

      it "should generate params { :controller => '<%= membership_plural %>', action => 'create', :<%= group_singular %>_id => 1 } from POST /<%= group_plural %>/1/<%= membership_plural %>" do
        params_from(:post, "/<%= group_plural %>/1/<%= membership_plural %>").should == {:controller => "<%= membership_plural %>", :action => "create", :<%= group_singular %>_id => "1"}
      end

      it "should generate params { :controller => '<%= membership_plural %>', action => 'show', id => '1', :<%= group_singular %>_id => 1 } from GET /<%= group_plural %>/1/<%= membership_plural %>/1" do
        params_from(:get, "/<%= group_plural %>/1/<%= membership_plural %>/1").should == {:controller => "<%= membership_plural %>", :action => "show", :id => "1", :<%= group_singular %>_id => "1"}
      end

      it "should generate params { :controller => '<%= membership_plural %>', action => 'edit', id => '1', :<%= group_singular %>_id => 1 } from GET /<%= group_plural %>/1/<%= membership_plural %>/1/edit" do
        params_from(:get, "/<%= group_plural %>/1/<%= membership_plural %>/1/edit").should == {:controller => "<%= membership_plural %>", :action => "edit", :id => "1", :<%= group_singular %>_id => "1"}
      end

      it "should generate params { :controller => '<%= membership_plural %>', action => 'update', id => '1', :<%= group_singular %>_id => 1 } from PUT /<%= group_plural %>/1/<%= membership_plural %>/1" do
        params_from(:put, "/<%= group_plural %>/1/<%= membership_plural %>/1").should == {:controller => "<%= membership_plural %>", :action => "update", :id => "1", :<%= group_singular %>_id => "1"}
      end

      it "should generate params { :controller => '<%= membership_plural %>', action => 'destroy', id => '1', :<%= group_singular %>_id => 1 } from DELETE /<%= group_plural %>/1/<%= membership_plural %>/1" do
        params_from(:delete, "/<%= group_plural %>/1/<%= membership_plural %>/1").should == {:controller => "<%= membership_plural %>", :action => "destroy", :id => "1", :<%= group_singular %>_id => "1"}
      end
    end

    describe "for <%= user_plural %>" do
      it "should generate params { :controller => '<%= membership_plural %>', action => 'index', :<%= user_singular %>_id => 1 } from GET /<%= user_plural %>/1/<%= membership_plural %>" do
        params_from(:get, "/<%= user_plural %>/1/<%= membership_plural %>").should == {:controller => "<%= membership_plural %>", :action => "index", :<%= user_singular %>_id => "1"}
      end

      it "should generate params { :controller => '<%= membership_plural %>', action => 'new', :<%= user_singular %>_id => 1 } from GET /<%= user_plural %>/1/<%= membership_plural %>/new" do
        params_from(:get, "/<%= user_plural %>/1/<%= membership_plural %>/new").should == {:controller => "<%= membership_plural %>", :action => "new", :<%= user_singular %>_id => "1"}
      end

      it "should generate params { :controller => '<%= membership_plural %>', action => 'create', :<%= user_singular %>_id => 1 } from POST /<%= user_plural %>/1/<%= membership_plural %>" do
        params_from(:post, "/<%= user_plural %>/1/<%= membership_plural %>").should == {:controller => "<%= membership_plural %>", :action => "create", :<%= user_singular %>_id => "1"}
      end

      it "should generate params { :controller => '<%= membership_plural %>', action => 'show', id => '1', :<%= user_singular %>_id => 1 } from GET /<%= user_plural %>/1/<%= membership_plural %>/1" do
        params_from(:get, "/<%= user_plural %>/1/<%= membership_plural %>/1").should == {:controller => "<%= membership_plural %>", :action => "show", :id => "1", :<%= user_singular %>_id => "1"}
      end

      it "should generate params { :controller => '<%= membership_plural %>', action => 'edit', id => '1', :<%= user_singular %>_id => 1 } from GET /<%= user_plural %>/1/<%= membership_plural %>/1/edit" do
        params_from(:get, "/<%= user_plural %>/1/<%= membership_plural %>/1/edit").should == {:controller => "<%= membership_plural %>", :action => "edit", :id => "1", :<%= user_singular %>_id => "1"}
      end

      it "should generate params { :controller => '<%= membership_plural %>', action => 'update', id => '1', :<%= user_singular %>_id => 1 } from PUT /<%= user_plural %>/1/<%= membership_plural %>/1" do
        params_from(:put, "/<%= user_plural %>/1/<%= membership_plural %>/1").should == {:controller => "<%= membership_plural %>", :action => "update", :id => "1", :<%= user_singular %>_id => "1"}
      end

      it "should generate params { :controller => '<%= membership_plural %>', action => 'destroy', id => '1', :<%= user_singular %>_id => 1 } from DELETE /<%= user_plural %>/1/<%= membership_plural %>/1" do
        params_from(:delete, "/<%= user_plural %>/1/<%= membership_plural %>/1").should == {:controller => "<%= membership_plural %>", :action => "destroy", :id => "1", :<%= user_singular %>_id => "1"}
      end
    end
  end
end
