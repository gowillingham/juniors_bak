require 'spec_helper'

describe PagesController do
  
  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
    end
  end

  describe "GET 'privacy'" do
    it "should be successful" do
      get :privacy
      response.should be_success
    end
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get :contact
      response.should be_success
    end
  end

  describe "GET 'about'" do
    it "should be successful" do
      get :about
      response.should be_success
    end
  end
end