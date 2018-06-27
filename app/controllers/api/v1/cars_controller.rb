class Api::V1::CarsController < ApplicationController
  def index
    @cars = Car.order('year DESC').paginate(:page => params[:page], :per_page => params[:per_page])

    render json: @cars
  end

  def create
    @car = Car.new(car_params)
    if @car.save
      render json: @car, status: :created
    else
      render json: @car.errors, status: 400
    end
  end

  def destroy
    @car = Car.find(params[:id])
    @car.destroy
  end

  private
    def car_params
      params.require(:car).permit(:name, :brand, :year)
    end
end
