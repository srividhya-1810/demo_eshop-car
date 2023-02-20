class CarsController < ApplicationController
    before_action :require_user

    def num_to_bool(x)
        if x==false
            return false
        else
            return true
        end
    end
    def index
       
        #if !params['status'].blank?
        #    params['status']=[0,1]
        #end
        
        @filter_options = {}
        
        @filter_options[:fuel_type] = [
        
           # Car::FuelType.constants.each do |type|
           #     @filter_options[:fuel_type].append(label: Car::FuelType::FUEL_TYPE_NAME_MAP[type], value: type, checked: num_to_bool(params.dig(:fuel_type,Car::FuelType.const_get(type))))
           # end

            {  label: "Petrol", value: Car::FuelType::PETROL.to_s, checked: params[:fuel_type]&.include?("0") },
            { label: "Diesel", value:Car::FuelType::DIESEL,checked: params[:fuel_type]&.include?("1") },
            { label: "Ethanol", value: Car::FuelType::ETHANOL,checked: params[:fuel_type]&.include?("2") },
            { label: "Electric Battery", value:Car::FuelType::ELECTRIC_BATTERY,checked: params[:fuel_type]&.include?("3") },
            { label: "Hydogen", value:Car::FuelType::HYDROGEN,checked: params[:fuel_type]&.include?("4")}
    ]
        

        @filter_options[:car_type]=[
            {label:"Suv",value: Car::CarType::SUV,checked: params[:car_type]&.include?("0") },
            {label:"Hatchback",value: Car::CarType::HATCHBACK,checked: params[:car_type]&.include?("1") },
            {label:"Crossover",value: Car::CarType::CROSSOVER,checked: params[:car_type]&.include?("2") },
            {label:"Convertible",value: Car::CarType::CONVERTIBLE,checked: params[:car_type]&.include?("3") },
            {label:"Sedan",value: Car::CarType::SEDAN,checked: params[:car_type]&.include?("4") },
            {label:"Sports",value: Car::CarType::SPORTS,checked: params[:car_type]&.include?("5") },
            {label:"Coupe",value: Car::CarType::COUPE,checked: params[:car_type]&.include?("6") },
            {label:"Minivan",value: Car::CarType::MINIVAN,checked: params[:car_type]&.include?("7") },
            {label:"Wagon",value: Car::CarType::WAGON,checked: params[:car_type]&.include?("8") },
            {label:"Pick Up Truck",value: Car::CarType::PICK_UP_TRUCK,checked: params[:car_type]&.include?("9") }
        ]

        @filter_options[:condition]=[
            {label:"New", value:Car::Condition::NEW,checked:params[:condition]&.include?("0")},
            {label:"Second Hand", value:Car::Condition::SECOND_HAND,checked:params[:condition]&.include?("1")}

        ]

        @filter_options[:status]=[
            {label:"Available", value:Car::Status::AVAILABLE,checked: params[:status]&.include?("0")},

            {label:"Sold", value:Car::Status::SOLD,checked:params[:status]&.include?("1")}

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
                @cars =Car.order('status')
            elsif !params['fuel_type'].blank? and !params['car_type'].blank? and !params['condition'].blank? and !params['status'].blank?
                
                @cars=Car.where(car_type:params['car_type'],fuel_type: params['fuel_type'],condition: params['condition'],status:params['status']).order('status')
            else
                search_hash = {}
                #if params['fuel_type'].blank?
                #    fu=[0,1,2,3,4]
                #else
                #    fu=params['fuel_type']
                #end
                #if params['car_type'].blank?
                #   ca=[0,1,2,3,4,5,6,7,8,9]
                #else
                #    ca=params['car_type']
                #end
                #if params['condition'].blank?
                #    con=[0,1]
                #else
                #    con=params['condition']
                #end
                #if params['status'].blank?
                #    status=[0,1]
                #else
                #    status=params[:status]
                #end
                
                if params['fuel_type'].present?
                    search_hash[:fuel_type]=params['fuel_type']
                end
                if params['car_type'].present?
                    search_hash[:car_type]=params['car_type']
                end
                if params['condition'].present?
                    search_hash[:condition]=params['condition']
                end
                if params['status'].present?
                    search_hash[:status]=params['status']
                end

                @cars=Car.where(search_hash).order('status')

            end
            
            if params['price']=="high to low"
                @cars=@cars.order('price DESC').paginate(page: params[:page], per_page: 8)
            elsif params['price']=="low to high"
                @cars=@cars.order('price').paginate(page: params[:page], per_page: 8)
            else
                @cars=@cars.paginate(page: params[:page], per_page: 8)
            end

        else
            if params['fuel_type'].blank? and params['car_type'].blank?  and  params['condition'].blank? and params['status'].blank?       
                @cars=Car.where(user_id: current_user.id).order('status').paginate(page:params[:page],per_page:8)
            else
            
                @cars=Car.where(user_id: current_user.id,car_type:params['car_type'],fuel_type: params['fuel_type'],condition: params['condition'],status:params['status']).order('status').paginate(page:params[:page],per_page:8)
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
            flash[:alert]="You dont have permission to create"
            redirect_to cars_path
        end
    end

    def edit
        if current_user.user_type==1 
            @car=Car.find(params[:id])
            

            if @car.user_id!=current_user.id
                flash[:alert]="You dont have rights"
                redirect_to cars_path
            end
        else
            flash[:alert]="You dont have rights"
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
    def comment
        if current_user.user_type==2
            @order_details=Order.find_by(car_id:params[:format])
        else
            flash[:alert]="You cannot see the comment"
            redirect_to cars_path
        end
        
        


    end

    def add_comment
     
        
        @order_details=Order.find(params[:format])
        @order_details.comment=params[:order][:comment]
        @order_details.save
        flash[:alert]="comments added"
        redirect_to cars_path
    end
    
    def add_to_order
        
        @order=Order.new
        @order.user_id=current_user.id
        @order.car_id=params[:format]
        @car_data=Car.find( @order.car_id)
        @car_data.status=1
        @order.save
        @car_data.save  
        
        PostMailer.with(user:current_user,car:@car_data).post_created.deliver_now
        flash[:notice]="Car added to order"
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