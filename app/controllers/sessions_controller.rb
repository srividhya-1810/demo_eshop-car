class SessionsController < ApplicationController
    def new
    end

    def create
        user=User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
            session[:user_id]=user.id
            redirect_to cars_path
        else
            flash.now[:alert]="THere is something wrong"
            render 'new'
        end


    end

    def destroy
        session[:user_id]=nil
        flash[:notice]="Logged out"
        redirect_to login_path
    end
end