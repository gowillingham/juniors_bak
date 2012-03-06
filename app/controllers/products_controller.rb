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
