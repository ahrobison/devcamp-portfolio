class PortfoliosController < ApplicationController
    layout 'portfolio'
    access all: [:show, :index, :angular], user: {except: [:destroy, :new, :create, :update, :edit, :sort]}, site_admin: :all

    def index
        @portfolio_items = Portfolio.by_position
    end

    def sort
      params[:order].each do |key, value|
        Portfolio.find(value[:id]).update(position: value[:position])
      end

      render nothing: true
    end

    def angular
      @angular_portfolio_items = Portfolio.angular
    end

    def new 
        @portfolio_item = Portfolio.new
    end

  def create
    @portfolio_item = Portfolio.new(portfolio_params)

    respond_to do |format|
      if @portfolio_item.save
        format.html { redirect_to portfolios_path, notice: 'You Portfolio was successfully created.' }
        format.json { render :show, status: :created, location: @portfolio_item}
      else
        format.html { render :new }
        
      end
    end
  end 
 
def edit
  @portfolio_item = Portfolio.find(params[:id])
end

  def update
    @portfolio_item = Portfolio.find(params[:id])

    respond_to do |format|
      if @portfolio_item.update(portfolio_params)
        format.html { redirect_to portfolios_path, notice: 'The record was successfully updated.' }
        format.json { render :show, status: :ok, location: @blog }
      else
        format.html { render :edit }
        
      end
    end
  end

  def show
    @portfolio_item = Portfolio.find(params[:id])
  end

  def destroy
    #Perform the lookup
    @portfolio_item = Portfolio.find(params[:id])
    
    #Destroy/delete the record      
    @portfolio_item.destroy

    #Redirect
    respond_to do |format|
      format.html { redirect_to portfolios_url, notice: 'Record was successfully removed.' }
    end
  end
  
  private

  def portfolio_params
    params.require(:portfolio).permit(:title,
                                      :subtitle,
                                      :body,
                                      :main_image,
                                      :thumb_image,
                                      technologies_attributes: [:id, :name, :_destroy]
                                    )
  end 

  def set_portfolio_item
    @portfolio_item = Portfolio.find(params[:id])
  end
end