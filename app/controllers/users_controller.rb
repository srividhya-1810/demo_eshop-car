class UsersController < ApplicationController
    before_action :no_need_to_login, only: [:index,:new]
    
    def create
         @user=User.new(params.permit(:name, :email,  :address , :phone_number, :user_type, :password))  #add validation
         if @user.save 
            session[:user_id]=@user.id        
            redirect_to login_path, notice: "Successfully Created Account "
         else
            flash.now[:alert]="Please fill in the details...."
            render :new, status: 302
         end

    end

    def index
        if session[:user_id]
            @user=User.find(session[:user_id])
        end
    end
    

    def new
        @user = User.new
    end


    def edit
        if current_user.id==params[:id].to_i
            @user=User.find(params[:id])
        else
            flash[:alert]="You can edit only your account"
            redirect_to cars_path
        end
    end

    def update
        @user=User.find(params[:id])
        if @user.update(user_params)
            flash[:notice]="Your account details was successfully updated"
            redirect_to cars_path
        else
            render 'edit', status: 302
        end


    end

    private
    def user_params
        params.require(:user).permit(:name, :email,  :address , :phone_number, :user_type, :password)
                                 
    end

end