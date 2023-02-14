class CarsController < ApplicationController
    before_action :require_user
    def index
        if params['fuel_type'].blank?
            if current_user.user_type==2
                
                @cars =Car.all.paginate(page: params[:page], per_page: 8)
            else
                @cars=Car.where(user_id: current_user.id).paginate(page:params[:page],per_page:8)
            end
        else
            @cars=Car.where(fuel_type: params['fuel_type']).paginate(page:params[:page],per_page:8)

        end


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
        
        @car = Car.new(params.permit(:brand, :price, :car_type, :fuel_type, :condition, :color, :status, images: []))
        
       
        
        @car.user_id= current_user.id  #check here
        if @car.save
            flash[:notice]="Car uploaded"
            redirect_to cars_path
        else
            render 'new', status: 302
        end
    end

    def length

    end

    def update
        
        @car = Car.find(params[:id])
        @car1=Car.new(params.require(:car).permit(:brand, :price, :car_type, :fuel_type, :condition, :color, :status, images: []))
        if @car1.images.count==0
            if @car.update(params.require(:car).permit(:brand, :price, :car_type, :fuel_type, :condition, :color, :status))
                flash[:notice]="Car updated"
                redirect_to cars_path
            else
                render 'edit', status: 302
            end
        else
            if @car.update(params.require(:car).permit(:brand, :price, :car_type, :fuel_type, :condition, :color, :status, images: []))
                flash[:notice]="Car updated"
                redirect_to cars_path
            else
                render 'edit', status: 302
            end

        end
    end
    def add_to_order
        
        @order=Order.new
        @order.user_id=current_user.id
        @order.car_id=params[:format]
        @car_data=Car.find( @order.car_id)
        @car_data.status=1
        @order.save
        @car_data.save  
        redirect_to cars_path
    end

    def display_ordered

        if current_user.user_type==2 
            @orders=Order.where(user_id: current_user.id).paginate(page: params[:page],per_page:1)
        else 
            @cars=Car.where(user_id: current_user.id)
            @seller_cars=@cars.where(status:1).paginate(page:params[:page],per_page:1)
        end 

    end


    #def search
   #     byebug
     #   @car1 = Car.new(params.require(:params).permit( :fuel_type))
    #    @cars=Car.where(fuel_type: @car1.fuel_type)
     #   redirect_to cars_path(@cars)
   # end
end