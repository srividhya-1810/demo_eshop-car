class UsersController < ApplicationController
    def create
         @user=User.new(params.permit(:name, :email, :password_digest, :address , :phone_number, :user_type))
         if @user.save 
          
            redirect_to index_path, notice: "Successfully CReated ACcount "
         else
            flash[:alert]="SOnething went wrong"
            render :new
         end

    end

    def index
    end
    

    def new
        @user = User.new
    end
end