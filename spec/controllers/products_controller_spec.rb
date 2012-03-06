require 'spec_helper'

describe ProductsController do
  render_views
  
  before(:each) do
    @user = User.create(:email => 'email@gmail.com', :password => 'p', :password_confirmation => 'p')
    login_user
    
    @attr = {
      :name => 'Session 1',
      :description => 'The description for the product', 
      :price => 70,
      :enabled => true
    }
  end
  
  describe "PUT 'update'" do
    before(:each) do
      @product = Product.create(@attr)
    end
    
    it "should require logged in user" do
      logout_user
      put :update, :id => @product, :product => @attr
      response.should redirect_to(new_session_path)
    end  
    
    it "should redirect to product#index on success" do
      put :update, :id => @product, :product => @attr.merge(:name => 'New name')
      response.should redirect_to(products_path)
      flash[:success].should =~ /saved/i
    end
    
    it "should change the product given valid attributes" do
      put :update, :id => @product, :product => @attr.merge(:name => 'New name')
      @product.reload.name.should eq('New name')
    end 
    
    it "should not change the product given invalid attributes" do
      put :update, :id => @product, :product => @attr.merge(:name => '')
      @product.reload.name.should eq(@attr[:name])
    end
  end
  
  describe "GET 'edit'" do
    before(:each) do
      @product = Product.create(@attr)
    end
    
    it "should require logged in user" do
      logout_user
      get :edit, :id => @product
      response.should redirect_to(new_session_path)
    end
    
    it "should be success" do
      get :edit, :id => @product
      response.should render_template('edit')
    end
  end
  
  describe "GET 'index'" do
    before(:each) do
      @product = Product.create(@attr)
    end
    
    it "should require logged in user" do
      logout_user
      post :create, :product => @attr
      response.should redirect_to(new_session_path)
    end
    
    it "should display a listing of the records" do
      get :index
      response.should render_template('index')
      response.should have_selector('td', :content => @product.name)
    end
  end 
  
  describe "POST 'create'" do
    it "should require logged in user" do
      logout_user
      post :create, :product => @attr
      response.should redirect_to(new_session_path)
    end
    
    it "should redirect to products#index on success" do
      post :create, :product => @attr
      response.should redirect_to(products_path)
      flash[:success].should =~ /saved/i
    end
    
    it "should add the product given valid attributes" do
      lambda do
        post :create, :product => @attr
      end.should change(Product, :count).by(1)
    end
    
    it "should not add the product given invalid attributes" do
      lambda do
        post :create, :product => @attr.merge(:name => '')
      end.should change(Product, :count).by(0)
    end
    
    it "should re-display index#new given invalid attributes" do
      post :create, :product => @attr.merge(:name => '')
      response.should render_template('new')
    end
  end
  
  describe "GET 'new'" do
    it "should require logged in user" do
      logout_user
      get :new
      response.should redirect_to(new_session_path)
    end
    
    it "should be success" do
      get :new
      response.should render_template('new')
    end
  end
end
