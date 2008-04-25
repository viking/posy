require File.dirname(__FILE__) + '/../spec_helper'

describe <%= membership_plural_class %>Controller do

  describe "when not logged in" do

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

    it "should redirect to /<%= session_plural %>/new on POST to create" do
      post :create
      response.should redirect_to(:controller => "<%= session_plural %>", :action => "new") 
    end

    it "should redirect to /<%= session_plural %>/new on DELETE to destroy" do
      delete :destroy, :id => "1"
      response.should redirect_to(:controller => "<%= session_plural %>", :action => "new") 
    end
  end

  describe "when logged in as admin" do
    include AuthenticatedTestHelper
    fixtures :<%= user_plural %>, :<%= group_plural %>, :<%= membership_plural %>, :<%= permission_plural %>

    before(:each) do
      login_as(:admin)
      @<%= membership_singular %> = mock_model(<%= membership_class %>)
      @<%= group_singular %> = mock_model(<%= group_class %>)
      @<%= user_singular %>  = mock_model(<%= user_class %>)
    end
    
    describe "handling GET /<%= membership_plural %>" do

      before(:each) do
        <%= membership_class %>.stub!(:find).and_return([@<%= membership_singular %>])
        get :index
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @<%= membership_plural %>" do
        assigns[:<%= membership_plural %>].should == [@<%= membership_singular %>] 
      end
    end

    describe "handling GET /<%= membership_plural %>/1" do

      before(:each) do
        <%= membership_class %>.stub!(:find).and_return(@<%= membership_singular %>)
        get :show, :id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @<%= membership_singular %>" do
        assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
      end
    end

    describe "handling GET /<%= membership_plural %>/new" do

      before(:each) do
        <%= membership_class %>.stub!(:new).and_return(@<%= membership_singular %>)
        <%= user_class %>.stub!(:find).and_return([@<%= user_singular %>])
        <%= group_class %>.stub!(:find).and_return([@<%= group_singular %>])

        get :new
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @<%= membership_singular %>" do
        assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
      end

      it "should set @<%= user_plural %>" do
        assigns[:<%= user_plural %>].should == [@<%= user_singular %>]
      end

      it "should set @<%= group_plural %>" do
        assigns[:<%= group_plural %>].should == [@<%= group_singular %>]
      end
    end

    describe "handling POST /<%= membership_plural %>" do

      before(:each) do
        <%= membership_class %>.stub!(:new).and_return(@<%= membership_singular %>)
        @<%= membership_singular %>.stub!(:save).and_return(true)
      end

      it "should redirect to /<%= membership_plural %>/:id when valid" do
        post :create
        response.should redirect_to(<%= membership_singular %>_url(@<%= membership_singular %>))
      end

      it "should render 'new' when invalid" do
        @<%= membership_singular %>.stub!(:save).and_return(false)
        post :create
        response.should render_template("new")
      end

      it "should set @<%= membership_singular %>" do
        post :create
        assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
      end
    end

    describe "handling DELETE /<%= membership_plural %>/1" do

      before(:each) do
        <%= membership_class %>.stub!(:find).and_return(@<%= membership_singular %>)
        @<%= membership_singular %>.stub!(:destroy).and_return(@<%= membership_singular %>)

        delete :destroy, :id => '1'
      end

      it "should redirect to /<%= membership_plural %>" do
        response.should redirect_to("/<%= membership_plural %>")
      end

      it "should set @<%= membership_singular %>" do
        assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
      end
    end

    describe "handling GET /<%= group_plural %>/1/<%= membership_plural %>" do

      before(:each) do
        @<%= group_singular %>.stub!(:<%= membership_plural %>).and_return([@<%= membership_singular %>])
        <%= group_class %>.stub!(:find).and_return(@<%= group_singular %>)

        get :index, :<%= group_singular %>_id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @<%= membership_plural %>" do
        assigns[:<%= membership_plural %>].should == [@<%= membership_singular %>] 
      end

      it "should set @<%= group_singular %>" do
        assigns[:<%= group_singular %>].should == @<%= group_singular %> 
      end
    end

    describe "handling GET /<%= group_plural %>/1/<%= membership_plural %>/1" do

      before(:each) do
        <%= group_class %>.stub!(:find).and_return(@<%= group_singular %>)
        @<%= membership_singular %>_association = stub("association", :find => @<%= membership_singular %>)
        @<%= group_singular %>.stub!(:<%= membership_plural %>).and_return(@<%= membership_singular %>_association)

        get :show, :id => "1", :<%= group_singular %>_id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @<%= membership_singular %>" do
        assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
      end

      it "should set @<%= group_singular %>" do
        assigns[:<%= group_singular %>].should == @<%= group_singular %>
      end
    end

    describe "handling GET /<%= group_plural %>/1/<%= membership_plural %>/new" do

      before(:each) do
        <%= group_class %>.stub!(:find).and_return(@<%= group_singular %>)
        <%= user_class %>.stub!(:find).and_return([@<%= user_singular %>])
        @<%= membership_singular %>_association = stub("association", :build => @<%= membership_singular %>)
        @<%= group_singular %>.stub!(:<%= membership_plural %>).and_return(@<%= membership_singular %>_association)

        get :new, :<%= group_singular %>_id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @<%= membership_singular %>" do
        assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
      end

      it "should set @<%= group_singular %>" do
        assigns[:<%= group_singular %>].should == @<%= group_singular %>
      end

      it "should have @<%= user_plural %>" do
        assigns[:<%= user_plural %>].should == [@<%= user_singular %>] 
      end
    end

    describe "handling POST /<%= group_plural %>/1/<%= membership_plural %>" do

      before(:each) do
        @<%= membership_singular %>.stub!(:save).and_return(true)
        <%= group_class %>.stub!(:find).and_return(@<%= group_singular %>)
        <%= user_class %>.stub!(:find).and_return([@<%= user_singular %>])
        @<%= membership_singular %>_association = stub("association", :build => @<%= membership_singular %>)
        @<%= group_singular %>.stub!(:<%= membership_plural %>).and_return(@<%= membership_singular %>_association)
      end

      def do_post
        post :create, :<%= group_singular %>_id => "1"
      end

      it "should redirect to /<%= group_plural %>/:id/<%= membership_plural %>/:id when valid" do
        do_post
        response.should redirect_to(<%= group_singular %>_<%= membership_singular %>_url(@<%= group_singular %>, @<%= membership_singular %>))
      end

      it "should render 'new' when invalid" do
        @<%= membership_singular %>.stub!(:save).and_return(false)

        do_post
        response.should render_template("new")
      end

      it "should set @<%= membership_singular %>" do
        do_post
        assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
      end

      it "should set @<%= group_singular %>" do
        do_post
        assigns[:<%= group_singular %>].should == @<%= group_singular %>
      end

      it "should set @<%= user_plural %>" do
        do_post
        assigns[:<%= user_plural %>].should == [@<%= user_singular %>] 
      end
    end

    describe "handling DELETE /<%= group_plural %>/1/<%= membership_plural %>/1" do

      before(:each) do
        @<%= membership_plural %> = [@<%= membership_singular %>]
        @<%= membership_singular %>_association = stub("association", :find => @<%= membership_singular %>)
        <%= group_class %>.stub!(:find).and_return(@<%= group_singular %>)
        @<%= group_singular %>.stub!(:<%= membership_plural %>).and_return(@<%= membership_singular %>_association)
        @<%= membership_singular %>.stub!(:destroy).and_return(@<%= membership_singular %>)

        delete :destroy, :id => '1', :<%= group_singular %>_id => "1"
      end

      it "should redirect to /<%= group_plural %>/1/<%= membership_plural %>" do
        response.should redirect_to(<%= group_singular %>_<%= membership_plural %>_url(@<%= group_singular %>))
      end

      it "should set @<%= membership_singular %>" do
        assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
      end

      it "should set @<%= group_singular %>" do
        assigns[:<%= group_singular %>].should == @<%= group_singular %>
      end
    end

    describe "handling GET /<%= user_plural %>/1/<%= membership_plural %>" do

      before(:each) do
        @<%= user_singular %>.stub!(:<%= membership_plural %>).and_return([@<%= membership_singular %>])
        <%= user_class %>.stub!(:find).and_return(@<%= user_singular %>)

        get :index, :<%= user_singular %>_id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @<%= membership_plural %>" do
        assigns[:<%= membership_plural %>].should == [@<%= membership_singular %>] 
      end

      it "should set @<%= user_singular %>" do
        assigns[:<%= user_singular %>].should == @<%= user_singular %> 
      end
    end

    describe "handling GET /<%= user_plural %>/1/<%= membership_plural %>/1" do

      before(:each) do
        <%= user_class %>.stub!(:find).and_return(@<%= user_singular %>)
        @<%= membership_singular %>_association = stub("association", :find => @<%= membership_singular %>)
        @<%= user_singular %>.stub!(:<%= membership_plural %>).and_return(@<%= membership_singular %>_association)

        get :show, :id => "1", :<%= user_singular %>_id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @<%= membership_singular %>" do
        assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
      end

      it "should set @<%= user_singular %>" do
        assigns[:<%= user_singular %>].should == @<%= user_singular %>
      end
    end

    describe "handling GET /<%= user_plural %>/1/<%= membership_plural %>/new" do

      before(:each) do
        <%= user_class %>.stub!(:find).and_return(@<%= user_singular %>)
        <%= group_class %>.stub!(:find).and_return([@<%= group_singular %>])
        @<%= membership_singular %>_association = stub("association", :build => @<%= membership_singular %>)
        @<%= user_singular %>.stub!(:<%= membership_plural %>).and_return(@<%= membership_singular %>_association)

        get :new, :<%= user_singular %>_id => "1"
      end

      it "should be successful" do
        response.should be_success
      end

      it "should set @<%= membership_singular %>" do
        assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
      end

      it "should set @<%= user_singular %>" do
        assigns[:<%= user_singular %>].should == @<%= user_singular %>
      end

      it "should have @<%= group_plural %>" do
        assigns[:<%= group_plural %>].should == [@<%= group_singular %>] 
      end
    end

    describe "handling POST /<%= user_plural %>/1/<%= membership_plural %> as admin" do

      before(:each) do
        @<%= membership_singular %>.stub!(:save).and_return(true)
        <%= user_class %>.stub!(:find).and_return(@<%= user_singular %>)
        <%= group_class %>.stub!(:find).and_return([@<%= group_singular %>])
        @<%= membership_singular %>_association = stub("association", :build => @<%= membership_singular %>)
        @<%= user_singular %>.stub!(:<%= membership_plural %>).and_return(@<%= membership_singular %>_association)
      end

      def do_post
        post :create, :<%= user_singular %>_id => "1"
      end

      it "should redirect to /<%= user_plural %>/:id/<%= membership_plural %>/:id when valid" do
        do_post
        response.should redirect_to(<%= user_singular %>_<%= membership_singular %>_url(@<%= user_singular %>, @<%= membership_singular %>))
      end

      it "should render 'new' when invalid" do
        @<%= membership_singular %>.stub!(:save).and_return(false)

        do_post
        response.should render_template("new")
      end

      it "should set @<%= membership_singular %>" do
        do_post
        assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
      end

      it "should set @<%= user_singular %>" do
        do_post
        assigns[:<%= user_singular %>].should == @<%= user_singular %>
      end

      it "should set @<%= group_plural %>" do
        do_post
        assigns[:<%= group_plural %>].should == [@<%= group_singular %>] 
      end
    end

    describe "handling DELETE /<%= user_plural %>/1/<%= membership_plural %>/1" do

      before(:each) do
        @<%= membership_plural %> = [@<%= membership_singular %>]
        @<%= membership_singular %>_association = stub("association", :find => @<%= membership_singular %>)
        <%= user_class %>.stub!(:find).and_return(@<%= user_singular %>)
        @<%= user_singular %>.stub!(:<%= membership_plural %>).and_return(@<%= membership_singular %>_association)
        @<%= membership_singular %>.stub!(:destroy).and_return(@<%= membership_singular %>)

        delete :destroy, :id => '1', :<%= user_singular %>_id => "1"
      end

      it "should redirect to /<%= user_plural %>/1/<%= membership_plural %>" do
        response.should redirect_to(<%= user_singular %>_<%= membership_plural %>_url(@<%= user_singular %>))
      end

      it "should set @<%= membership_singular %>" do
        assigns[:<%= membership_singular %>].should == @<%= membership_singular %>
      end

      it "should set @<%= user_singular %>" do
        assigns[:<%= user_singular %>].should == @<%= user_singular %>
      end
    end
  end
end
