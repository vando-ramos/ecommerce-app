class WarehousesController < ApplicationController
  def index
    @warehouses = Warehouse.all
  end

  def show
    @warehouse = Warehouse.find(params[:id])

    if @warehouse
      render :show
    else
      redirect_to root_path, alert: 'Unable to load the warehouse'
    end
  end
end
