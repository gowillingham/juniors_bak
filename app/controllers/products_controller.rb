class ProductsController < ApplicationController
  before_filter :require_login
  
  def new
    @product = Product.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def index
  end

  def show
  end

  def destroy
  end

end
