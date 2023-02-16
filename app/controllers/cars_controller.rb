class CarsController < ApplicationController
    before_action :require_user

    def num_to_bool(x)
        if x==nil
            return false
        else
            return true
        end
    end
    def index
       
        if !params['status'].blank?
            params['status']=[0,1]
        end
       
        @filter_options = {}
        @filter_options[:fuel_type] = [
            {  label: "Petrol", value: Car::FuelType::PETROL, checked: num_to_bool(params.dig(:fuel_type,Car::FuelType::PETROL)) },
            { label: "Diesel", value:Car::FuelType::DIESEL,checked: num_to_bool(params.dig(:fuel_type,Car::FuelType::DIESEL)) },
            { label: "Ethanol", value:Car::FuelType::ETHANOL,checked: num_to_bool(params.dig(:fuel_type,Car::FuelType::ETHANOL)) },
            { label: "Electric Battery", value:Car::FuelType::ELECTRIC_BATTERY,checked: num_to_bool(params.dig(:fuel_type,Car::FuelType::ELECTRIC_BATTERY)) },
            { label: "Hydogen", value:Car::FuelType::HYDROGEN,checked: num_to_bool(params.dig(:fuel_type,Car::FuelType::HYDROGEN)) }
            
        ]

        @filter_options[:car_type]=[
            {label:"Suv",value: Car::CarType::SUV,checked: num_to_bool(params.dig(:car_type,Car::CarType::SUV)) },
            {label:"Hatchback",value: Car::CarType::HATCHBACK,checked: num_to_bool(params.dig(:car_type,Car::CarType::HATCHBACK)) },
            {label:"Crossover",value: Car::CarType::CROSSOVER,checked: num_to_bool(params.dig(:car_type,Car::CarType::CROSSOVER)) },
            {label:"Convertible",value: Car::CarType::CONVERTIBLE,checked: num_to_bool(params.dig(:car_type,Car::CarType::CONVERTIBLE)) },
            {label:"Sedan",value: Car::CarType::SEDAN,checked: num_to_bool(params.dig(:car_type,Car::CarType::SEDAN)) },
            {label:"Sports",value: Car::CarType::SPORTS,checked: num_to_bool(params.dig(:car_type,Car::CarType::SPORTS)) },
            {label:"Coupe",value: Car::CarType::COUPE,checked: num_to_bool(params.dig(:car_type,Car::CarType::COUPE)) },
            {label:"Minivan",value: Car::CarType::MINIVAN,checked: num_to_bool(params.dig(:car_type,Car::CarType::MINIVAN)) },
            {label:"Wagon",value: Car::CarType::WAGON,checked: num_to_bool(params.dig(:car_type,Car::CarType::WAGON)) },
            {label:"Pick Up Truck",value: Car::CarType::PICK_UP_TRUCK,checked: num_to_bool(params.dig(:car_type,Car::CarType::PICK_UP_TRUCK)) }
        ]

        @filter_options[:condition]=[
            {label:"New", value:Car::Condition::NEW,checked:num_to_bool(params.dig(:condition,Car::Condition::NEW))},
            {label:"Second Hand", value:Car::Condition::SECOND_HAND,checked:num_to_bool(params.dig(:condition,Car::Condition::SECOND_HAND))}

        ]

        @filter_options[:status]=[
            {label:"Include Sold", value:Car::Status::SOLD,checked:num_to_bool(params.dig(:status,Car::Status::SOLD))}

        ]

        
#
      #  @filter_options[:fuel_type] = Car::FuelType.all.map do |fuel_type|
      #      { label: Car::FuelType::FUEL_TYPE_NAME_MAP[fuel_type], value: fuel_type, checked: params[:fuel_type] == fuel_type}
      #  end
#
      #  @filter_options[:fuel_type].each do |fuel_type|
      #      <label>fuel_type[label</label>
      #      <input type="checkbox" value=fuel_type.value checked=fuel_type.checked>
      #  end
#
        
        if current_user.user_type==2
            if params['fuel_type'].blank? and params['car_type'].blank? and params['condition'].blank? and params['status'].blank?
                @cars =Car.where(status:0).paginate(page: params[:page], per_page: 8)
            elsif !params['fuel_type'].blank? and !params['car_type'].blank? and !params['condition'].blank? and !params['status'].blank?
                
                @cars=Car.where(car_type:params['car_type'],fuel_type: params['fuel_type'],condition: params['condition'],status:params['status']).paginate(page:params[:page],per_page:8)
            else
                if params['fuel_type'].blank?
                    fu=[0,1,2,3,4]
                else
                    fu=params['fuel_type']
                end
                if params['car_type'].blank?
                   ca=[0,1,2,3,4,5,6,7,8,9]
                else
                    ca=params['car_type']
                end
                if params['condition'].blank?
                    con=[0,1]
                else
                    con=params['condition']
                end
                if params['status'].blank?
                    status=[0]
                else
                    status=[0,1]
                    params['status']=[0,1]
                end
                @cars=Car.where(car_type:ca,fuel_type: fu,condition: con,status:status).paginate(page:params[:page],per_page:8)

            end
        

        else
            if params['fuel_type'].blank? and params['car_type'].blank?  and  params['condition'].blank? and params['status'].blank?       
                @cars=Car.where(user_id: current_user.id).paginate(page:params[:page],per_page:8)
            else
            
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