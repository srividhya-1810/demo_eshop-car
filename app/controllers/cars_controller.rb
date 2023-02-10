class CarsController < ApplicationController
    #before_action :require_user
    def index
        @cars =Car.all

    end

    def show
        @car=Car.find(params[:id])
    end

    def new
        @car=Car.new
    end

    def edit
        @car=Car.find(params[:id])
    end

    def create
       
        #@car = Car.new(params.require(:car).permit(:brand, :price, :car_type, :fuel_type, :condition, :color, :status, images: []))
        params_hash = params.permit(:brand, :price, :car_type, :fuel_type, :condition, :color, :status, images: []).to_unsafe_h
       
        @car = Car.new(params_hash)
        
        if @car.save
            flash[:notice]="Car uploaded"
            redirect_to cars_path
        else
            render 'new', status: 302
        end
    end


    def update
        @car = Car.find(params[:id])
        if @car.update(params.require(:car).permit(:brand, :price, :car_type, :fuel_type, :condition, :color, :status, images: []))
            flash[:notice]="Car updated"
            redirect_to cars_path
        else
            render 'edit', status: 302
        end
    end
end