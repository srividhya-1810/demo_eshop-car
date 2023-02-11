class OrdersController < ApplicationController

    def new
        @order=Order.new
    end

    def create
        @order=Order.new
        @order.user_id=current_user
        #@order.car_id=
    end
end