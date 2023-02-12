class SessionsController < ApplicationController
    before_action :no_need_to_login, only: [:new]

    def new
       # @user = User.new
    end

    def create
        user=User.find_by(email: params[:session][:email].downcase)
        if user && user.authenticate(params[:session][:password])
            session[:user_id]=user.id
            flash[:notice]="Logged in Successfully"
            redirect_to cars_path
        else
            flash.now[:alert]="Please check the credentials"
            render 'new', status: 302
        end


    end

    def destroy
        session[:user_id]=nil
        flash[:notice]="Logged out"
        redirect_to root_path
    end
end