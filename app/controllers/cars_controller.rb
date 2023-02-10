class CarsController < ApplicationController
    #before_action :require_user
    def index
        @cars =Car.all

    end

    def show
        @car=Car.find(params[:id])
    end

    def new
    end

    def create
        #@car = Car.new(params.require(:car).permit(:brand, :price, :car_type, :fuel_type, :condition))
    end
end