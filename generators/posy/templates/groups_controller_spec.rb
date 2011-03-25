require File.dirname(__FILE__) + '/../spec_helper'

describe <%= group_plural_class %>Controller do
  include AuthenticatedTestHelper
  fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

  describe "when no one is logged in" do

    it "should redirect to /<%= session_plural %>/new on GET to index" do
      get :index
      response.should redirect_to(:controller => "<%= session_plural %>", :action => "new")
    end

    it "should redirect to /<%= session_plural %>/new on GET to new" do
      get :new
      response.should redirect_to(:controller => "<%= session_plural %>", :action => "new")
    end

    it "should redirect to /<%= session_plural %>/new on GET to show" do
      get :show, :id => "1"
      response.should redirect_to(:controller => "<%= session_plural %>", :action => "new")
    end

    it "should redirect to /<%= session_plural %>/new on GET to edit" do
      get :edit, :id => "1"
      response.should redirect_to(:controller => "<%= session_plural %>", :action => "new")
    end

    it "should redirect to /<%= session_plural %>/new on POST to create" do
      post :create
      response.should redirect_to(:controller => "<%= session_plural %>", :action => "new")
    end

    it "should redirect to /<%= session_plural %>/new on PUT to update" do
      put :update, :id => "1"
      response.should redirect_to(:controller => "<%= session_plural %>", :action => "new")
    end

    it "should redirect to /<%= session_plural %>/new on DELETE to destroy" do
      delete :destroy, :id => "1"
      response.should redirect_to(:controller => "<%= session_plural %>", :action => "new")
    end
  end

  describe "when logged in as admin" do

    before(:each) do
      login_as(:admin)
      @<%= group_singular %> = mock_model(<%= group_class %>)
    end

    describe "handling GET /<%= group_plural %>" do

      before(:each) do
        <%= group_class %>.stub(:find).and_return([@<%= group_singular %>])
        get :index
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @<%= group_plural %>" do
        assigns[:<%= group_plural %>].should == [@<%= group_singular %>]
      end
    end

    describe "handling GET /<%= group_plural %>/1" do

      before(:each) do
        <%= group_class %>.stub(:find).and_return(@<%= group_singular %>)

        get :show, :id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @<%= group_singular %>" do
        assigns[:<%= group_singular %>].should == @<%= group_singular %>
      end
    end

    describe "handling GET /<%= group_plural %>/new" do

      before(:each) do
        <%= group_class %>.stub(:new).and_return(@<%= group_singular %>)

        get :new
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @<%= group_singular %>" do
        assigns[:<%= group_singular %>].should == @<%= group_singular %>
      end
    end

    describe "handling GET /<%= group_plural %>/1/edit" do

      before(:each) do
        <%= group_class %>.stub(:find).and_return(@<%= group_singular %>)

        get :edit, :id => "1"
      end

      it "should GET /<%= group_plural %>/1/edit successfully" do
        response.should be_success
      end

      it "should have a @<%= group_singular %> after GET /<%= group_plural %>/1/edit" do
        assigns[:<%= group_singular %>].should == @<%= group_singular %>
      end
    end

    describe "handling POST /<%= group_plural %>" do

      before(:each) do
        <%= group_class %>.stub(:new).and_return(@<%= group_singular %>)
        @<%= group_singular %>.stub(:save).and_return(true)
      end

      it "should redirect to /<%= group_plural %>/:id when valid" do
        post :create
        response.should redirect_to(<%= group_singular %>_url(@<%= group_singular %>))
      end

      it "should render 'new' when invalid" do
        @<%= group_singular %>.stub(:save).and_return(false)
        post :create
        response.should render_template("new")
      end

      it "should set @<%= group_singular %>" do
        post :create
        assigns[:<%= group_singular %>].should == @<%= group_singular %>
      end
    end

    describe "handling PUT /<%= group_plural %>/1" do

      before(:each) do
        <%= group_class %>.stub(:find).and_return(@<%= group_singular %>)
        @<%= group_singular %>.stub(:update_attributes).and_return(true)
      end

      it "should redirect to /<%= group_plural %>/:id when valid" do
        put :update, :id => '1'
        response.should redirect_to(<%= group_singular %>_url(@<%= group_singular %>))
      end

      it "should render 'edit' when invalid" do
        @<%= group_singular %>.stub(:update_attributes).and_return(false)
        put :update, :id => '1'
        response.should render_template("edit")
      end

      it "should set @<%= group_singular %>" do
        put :update, :id => '1'
        assigns[:<%= group_singular %>].should == @<%= group_singular %>
      end
    end

    describe "handling DELETE /<%= group_plural %>/1" do

      before(:each) do
        <%= group_class %>.stub(:find).and_return(@<%= group_singular %>)
        @<%= group_singular %>.stub(:destroy).and_return(@<%= group_singular %>)

        delete :destroy, :id => '1'
      end

      it "should redirect to /<%= group_plural %>" do
        response.should redirect_to(<%= group_plural %>_url)
      end

      it "should set @<%= group_singular %>" do
        assigns[:<%= group_singular %>].should == @<%= group_singular %>
      end
    end
  end
end
