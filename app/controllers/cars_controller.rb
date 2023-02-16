class CarsController < ApplicationController
    before_action :require_user
    def index

     #   @filter_options = {}
     #   @filter_options[:fuel_type] = [
     #       { label: "Petrol", value: Car::FuelType::PETROL, checked: params.dig(:fuel_type).include?(Car::FuelType::PETROL) },
     #       {}
     #   ]
#
     #   @filter_options[:fuel_type] = Car::FuelType.all.map do |fuel_type|
     #       { label: Car::FuelType::FUEL_TYPE_NAME_MAP[fuel_type], value: fuel_type, checked: params[:fuel_type].include?(fuel_type)}
     #   end
#
     #   @filter_options[:fuel_type].each do |fuel_type|
     #       <label>fuel_type[:label]</label>
     #       <input type="checkbox" value=fuel_type.value checked=fuel_type.checked>
     #   end
#

        if current_user.user_type==2
            if params['fuel_type'].blank? and params['car_type'].blank? and params['condition'].blank? and params['status'].blank?
                @cars =Car.all.paginate(page: params[:page], per_page: 8)
            elsif !params['fuel_type'].blank? and !params['car_type'].blank? and !params['condition'].blank? and !params['status'].blank?
                @cars=Car.where(car_type:params['car_type'],fuel_type: params['fuel_type'],condition: params['condition'],status:params['status']).paginate(page:params[:page],per_page:8)
            else
                if params['fuel_type'].blank?
                    params['fuel_type']=[0,1,2,3,4]
                end
                if params['car_type'].blank?
                    params['car_type']=[0,1,2,3,4,5,6,7,8,9]
                end
                if params['condition'].blank?
                    params['condition']=[0,1]
                end
                if params['status'].blank?
                    params['status']=[0,1]
                end
                @cars=Car.where(car_type:params['car_type'],fuel_type: params['fuel_type'],condition: params['condition'],status:params['status']).paginate(page:params[:page],per_page:8)

            end
        

        else
            if params['fuel_type'].blank? and params['car_type'].blank?  and  params['condition'].blank? and params['status'].blank?       
                @cars=Car.where(user_id: current_user.id).paginate(page:params[:page],per_page:8)
            elsif !params['fuel_type'].blank? and !params['car_type'].blank? and !params['condition'].blank? and !params['status'].blank?
                @cars=Car.where(user_id:current_user.id,car_type:params['car_type'],fuel_type: params['fuel_type'],condition: params['condition'],status:params['status']).paginate(page:params[:page],per_page:8)
            else
                if params['fuel_type'].blank?
                    params['fuel_type']=[0,1,2,3,4]
                end
                if params['car_type'].blank?
                    params['car_type']=[0,1,2,3,4,5,6,7,8,9]
                end
                if params['condition'].blank?
                    params['condition']=[0,1]
                end
                if params['status'].blank?
                    params['status']=[0,1]
                end
                @cars=Car.where(user_id: current_user.id,car_type:params['car_type'],fuel_type: params['fuel_type'],condition: params['condition'],status:params['status']).paginate(page:params[:page],per_page:8)
            end


        end

    end

    def show
        @car=Car.find(params[:id])
    end

    def new
        if current_user.user_type==1
            @car=Car.new
        else
            redirect_to cars_path
        end
    end

    def edit
        if current_user.user_type==1 
            @car=Car.find(params[:id])
            if @car.user_id!=current_user.id
                redirect_to cars_path
            end
        else
            redirect_to cars_path
        end
    end

    def create
        
        @car = Car.new(params.permit(:brand, :price, :car_type, :fuel_type, :condition, :color, :status, images: []))
        
       
        @car.brand=@car.brand.upcase
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
            if @car.update(params.require(:car).permit(:brand.upcase, :price, :car_type, :fuel_type, :condition, :color, :status))
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