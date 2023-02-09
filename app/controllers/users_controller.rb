class UsersController < ApplicationController
    def create
         @user=User.new(params.permit(:name, :email,  :address , :phone_number, :user_type, :password))  #add validation
         if @user.save 
            session[:user_id]=@user.id        
            redirect_to login_path, notice: "Successfully CReated ACcount "
         else
            flash[:alert]="SOnething went wrong"
            render :new
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
end