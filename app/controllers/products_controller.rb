class ProductsController < ApplicationController
  before_filter :require_login
  
  def new
    @product = Product.new
  end

  def create
    @product = Product.new
    @product.update_attributes(params[:product])
    if @product.save
      flash[:success] = 'The product was saved'
      redirect_to products_path
    else
      render 'new'
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    @product.update_attributes(params[:product])
    if @product.save
      flash[:success] = 'The product was saved'
      redirect_to products_path
    else
      render 'edit'
    end
  end

  def index
    @products = Product.find(:all)
  end

  def show
  end

  def destroy
  end

end
